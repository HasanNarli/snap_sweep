import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/frosted.dart';
import '../../shared/widgets/photo_thumbnail.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/gallery_service.dart';
import '../gallery/photo_size_provider.dart';
import '../stats/cleanup_stats.dart';
import '../swipe/swipe_session.dart';
import 'cleanup_result.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  // Photos the user chose to keep after all.
  final _kept = <String>{};
  bool _deleting = false;

  void _toggle(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (!_kept.remove(id)) _kept.add(id);
    });
  }

  void _toggleAll(List<GalleryPhoto> marked) => setState(() {
    if (_kept.isEmpty) {
      _kept.addAll(marked.map((photo) => photo.id));
    } else {
      _kept.clear();
    }
  });

  Future<void> _delete(List<GalleryPhoto> selected) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _deleting = true);

    final ids = [for (final photo in selected) photo.id];
    // Read sizes before the files are gone.
    final sizes = await Future.wait(
      ids.map((id) => ref.read(photoSizeProvider(id).future)),
    );
    final sizeById = Map.fromIterables(ids, sizes);

    List<String> deleted;
    try {
      deleted = await ref.read(galleryServiceProvider).deletePhotos(ids);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.reviewDeleteFailed)));
      if (mounted) setState(() => _deleting = false);
      return;
    }
    if (!mounted) return;

    if (deleted.isEmpty) {
      setState(() => _deleting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.reviewDeleteCancelled)),
      );
      return;
    }

    final freed = deleted.fold<int>(0, (sum, id) => sum + (sizeById[id] ?? 0));
    await ref
        .read(cleanupStatsProvider.notifier)
        .record(photos: deleted.length, bytes: freed);
    if (!mounted) return;
    context.go(
      AppRoutes.result,
      extra: CleanupResult(photosDeleted: deleted.length, bytesFreed: freed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final marked =
        ref.watch(swipeSessionProvider).value?.toDelete ??
        const <GalleryPhoto>[];
    final selected = [
      for (final photo in marked)
        if (!_kept.contains(photo.id)) photo,
    ];
    final sizes = [
      for (final photo in selected)
        ref.watch(photoSizeProvider(photo.id)).value,
    ];
    final totalBytes = sizes.every((size) => size != null)
        ? sizes.fold<int>(0, (sum, size) => sum + size!)
        : null;
    final totalText = totalBytes == null
        ? null
        : context.formatSize(totalBytes);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              selected: selected.length,
              total: marked.length,
              allSelected: _kept.isEmpty,
              onToggleAll: marked.isEmpty ? null : () => _toggleAll(marked),
            ),
            Divider(color: palette.border.withValues(alpha: 0.6)),
            Expanded(
              child: marked.isEmpty
                  ? Center(
                      child: Text(
                        l10n.reviewEmpty,
                        style: textTheme.bodyMedium,
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                      children: [
                        _Summary(selected: selected.length, size: totalText),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                              ),
                          itemCount: marked.length,
                          itemBuilder: (context, index) {
                            final photo = marked[index];
                            return _ReviewTile(
                              photo: photo,
                              selected: !_kept.contains(photo.id),
                              onTap: _deleting ? null : () => _toggle(photo.id),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.page),
                        const _TrashNote(),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.reviewHint,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: palette.tertiaryLabel,
                          ),
                        ),
                      ],
                    ),
            ),
            if (marked.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: _ActionPanel(
                  selectedCount: selected.length,
                  size: totalText,
                  deleting: _deleting,
                  onDelete: selected.isEmpty || _deleting
                      ? null
                      : () => _delete(selected),
                  onKeepAll: _deleting
                      ? null
                      : () => context.go(AppRoutes.home),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.selected,
    required this.total,
    required this.allSelected,
    required this.onToggleAll,
  });

  final int selected;
  final int total;
  final bool allSelected;
  final VoidCallback? onToggleAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            RoundIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              color: palette.label,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              size: 40,
              iconSize: 18,
              plain: true,
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.reviewTitle, style: textTheme.titleMedium),
                  Text(
                    l10n.reviewSelectedOf(selected, total),
                    style: textTheme.labelMedium?.copyWith(
                      fontSize: 11,
                      color: palette.tertiaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            if (onToggleAll != null)
              TextButton(
                onPressed: onToggleAll,
                child: Text(
                  allSelected ? l10n.reviewDeselectAll : l10n.reviewSelectAll,
                  style: TextStyle(color: palette.label),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.selected, required this.size});

  final int selected;
  final String? size;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: palette.delete,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              l10n.reviewPhotosSelected(selected),
              style: textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
          ),
          if (size != null)
            Text(
              l10n.reviewMarkedSize(size!),
              style: textTheme.labelMedium?.copyWith(
                color: palette.tertiaryLabel,
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  const _ReviewTile({
    required this.photo,
    required this.selected,
    required this.onTap,
  });

  final GalleryPhoto photo;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final bytes = ref.watch(photoSizeProvider(photo.id)).value;
    final label = selected
        ? (bytes == null ? null : context.formatSize(bytes))
        : context.l10n.reviewKept;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: palette.fill),
            PhotoThumbnail(
              photoId: photo.id,
              size: AppConfig.gridThumbnailSize,
            ),
            AnimatedOpacity(
              opacity: selected ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: ColoredBox(color: palette.photoDim),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: selected
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: palette.delete,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: palette.onSolid,
                      ),
                    )
                  : Frosted(
                      tint: palette.photoGlassSubtle,
                      borderColor: palette.photoGlassSubtleBorder,
                      blur: 6,
                      child: const SizedBox.square(dimension: 18),
                    ),
            ),
            if (label != null)
              Positioned(
                left: 6,
                bottom: 4,
                child: Frosted(
                  radius: 4,
                  blur: 6,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: palette.onPhoto,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrashNote extends StatelessWidget {
  const _TrashNote();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final base = TextStyle(
      fontSize: 12,
      height: 1.42,
      color: palette.secondaryLabel,
    );
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: palette.card(radius: AppRadius.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: palette.fill,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 13,
              color: palette.secondaryLabel,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: base,
                children: [
                  TextSpan(text: l10n.reviewTrashNotePrefix),
                  TextSpan(
                    text: l10n.reviewTrashNoteBold,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.label,
                    ),
                  ),
                  TextSpan(text: l10n.reviewTrashNoteSuffix),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.selectedCount,
    required this.size,
    required this.deleting,
    required this.onDelete,
    required this.onKeepAll,
  });

  final int selectedCount;
  final String? size;
  final bool deleting;
  final VoidCallback? onDelete;
  final VoidCallback? onKeepAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final label = selectedCount == 0
        ? l10n.reviewNothingSelected
        : [
            l10n.reviewDeleteAction(selectedCount),
            if (size != null) '($size)',
          ].join(' ');

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: palette.floatingShadow,
      ),
      child: Frosted(
        radius: AppRadius.md,
        tint: palette.background.withValues(alpha: 0.85),
        borderColor: palette.border.withValues(alpha: 0.6),
        padding: const EdgeInsets.fromLTRB(11, 11, 11, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: palette.delete,
                foregroundColor: palette.onSolid,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              onPressed: onDelete,
              icon: deleting
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.onSolid,
                      ),
                    )
                  : const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(label),
            ),
            TextButton(
              onPressed: onKeepAll,
              child: Text(
                l10n.reviewKeepAll,
                style: TextStyle(color: palette.tertiaryLabel, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
