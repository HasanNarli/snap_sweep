import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/config/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/frosted.dart';
import '../../shared/widgets/photo_thumbnail.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/photo_size_provider.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photo, required this.dragPercent});

  final GalleryPhoto photo;

  // -100..100 from the swiper; negative means dragging left (delete).
  final int dragPercent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = (dragPercent.abs() / 100).clamp(0.0, 1.0);
    final deleting = dragPercent < 0;
    final tint = deleting ? palette.delete : palette.keep;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoThumbnail(
              photoId: photo.id,
              size: AppConfig.cardThumbnailSize,
            ),
            // Decision wash + badge while dragging.
            if (dragPercent != 0) ...[
              ColoredBox(color: tint.withValues(alpha: progress * 0.3)),
              Center(
                child: Opacity(
                  opacity: progress,
                  child: Transform.scale(
                    scale: 0.6 + 0.4 * progress,
                    child: _DecisionBadge(
                      icon: deleting
                          ? Icons.delete_rounded
                          : Icons.favorite_rounded,
                      color: tint,
                    ),
                  ),
                ),
              ),
            ],
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              child: _PhotoInfo(photo: photo),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecisionBadge extends StatelessWidget {
  const _DecisionBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 24)],
      ),
      child: Icon(icon, color: color, size: 52),
    );
  }
}

class _PhotoInfo extends ConsumerWidget {
  const _PhotoInfo({required this.photo});

  final GalleryPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat.yMMMd(context.localeTag).format(photo.createdAt);
    final bytes = ref.watch(photoSizeProvider(photo.id)).value;
    final text = [
      date,
      if (bytes != null) context.formatSize(bytes),
    ].join('  ·  ');

    return Frosted(
      tint: const Color(0x40000000),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
