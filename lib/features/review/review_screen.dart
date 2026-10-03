import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/photo_thumbnail.dart';
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
    final sizeSuffix = totalBytes == null
        ? ''
        : '  ·  ${context.formatSize(totalBytes)}';

    return Scaffold(
      appBar: AppBar(),
      body: marked.isEmpty
          ? Center(child: Text(l10n.reviewEmpty, style: textTheme.bodyLarge))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Large title + live summary.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.reviewTitle, style: textTheme.headlineLarge),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.reviewSelectedCount(selected.length) + sizeSuffix,
                        style: textTheme.bodyMedium?.copyWith(
                          color: palette.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.reviewHint, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
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
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.delete,
                      ),
                      onPressed: selected.isEmpty || _deleting
                          ? null
                          : () => _delete(selected),
                      child: _deleting
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              selected.isEmpty
                                  ? l10n.reviewNothingSelected
                                  : l10n.reviewDeleteAction(selected.length) +
                                        sizeSuffix,
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.photo,
    required this.selected,
    required this.onTap,
  });

  final GalleryPhoto photo;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoThumbnail(
              photoId: photo.id,
              size: AppConfig.gridThumbnailSize,
            ),
            // Kept photos fade back, Photos-app style.
            AnimatedOpacity(
              opacity: selected ? 0 : 0.55,
              duration: const Duration(milliseconds: 150),
              child: ColoredBox(color: palette.background),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? palette.delete : Colors.transparent,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Color(0x40000000), blurRadius: 4),
                  ],
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
