import 'package:flutter/material.dart';
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

  void _toggle(String id) => setState(() {
    if (!_kept.remove(id)) _kept.add(id);
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: SafeArea(
        child: marked.isEmpty
            ? Center(child: Text(l10n.reviewEmpty))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      l10n.reviewHint,
                      style: TextStyle(color: context.palette.muted),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: AppSpacing.sm,
                            crossAxisSpacing: AppSpacing.sm,
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
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: context.palette.delete,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: selected.isEmpty || _deleting
                          ? null
                          : () => _delete(selected),
                      icon: _deleting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.delete_rounded),
                      label: Text(
                        selected.isEmpty
                            ? l10n.reviewNothingSelected
                            : [
                                l10n.reviewDeleteAction(selected.length),
                                if (totalBytes != null)
                                  '(${context.formatSize(totalBytes)})',
                              ].join(' '),
                      ),
                    ),
                  ),
                ],
              ),
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoThumbnail(
              photoId: photo.id,
              size: AppConfig.gridThumbnailSize,
            ),
            // Dim photos the user decided to keep.
            AnimatedOpacity(
              opacity: selected ? 0 : 0.6,
              duration: const Duration(milliseconds: 150),
              child: const ColoredBox(color: Colors.black),
            ),
            Positioned(
              top: AppSpacing.xs,
              right: AppSpacing.xs,
              child: Icon(
                selected ? Icons.delete_rounded : Icons.favorite_rounded,
                color: selected ? palette.delete : palette.keep,
                shadows: const [Shadow(blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
