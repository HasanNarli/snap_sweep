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

    return Container(
      decoration: BoxDecoration(
        color: palette.fill,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0x0F000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 40,
            spreadRadius: -10,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            spreadRadius: -2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoThumbnail(photoId: photo.id, size: AppConfig.cardThumbnailSize),
          // Soft top/bottom scrim so the pill stays readable.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x40000000),
                  Color(0x00000000),
                  Color(0x66000000),
                ],
              ),
            ),
          ),
          // Decision wash + badge while dragging.
          if (dragPercent != 0) ...[
            ColoredBox(color: tint.withValues(alpha: progress * 0.25)),
            Center(
              child: Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: 0.6 + 0.4 * progress,
                  child: _DecisionBadge(
                    icon: deleting
                        ? Icons.delete_outline_rounded
                        : Icons.check_rounded,
                    color: tint,
                  ),
                ),
              ),
            ),
          ],
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Center(child: _MetadataPill(photo: photo)),
          ),
        ],
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
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 24)],
      ),
      child: Icon(icon, color: color, size: 44),
    );
  }
}

// Frosted "date • size" pill, Stitch metadata style.
class _MetadataPill extends ConsumerWidget {
  const _MetadataPill({required this.photo});

  final GalleryPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat.yMMMd(context.localeTag).format(photo.createdAt);
    final bytes = ref.watch(photoSizeProvider(photo.id)).value;
    const style = TextStyle(
      color: Color(0xF2FFFFFF),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3,
      height: 1.5,
    );

    return Frosted(
      tint: const Color(0x66000000),
      borderColor: const Color(0x26FFFFFF),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(date, style: style),
          if (bytes != null) ...[
            const _Dot(),
            Text(
              context.formatSize(bytes),
              style: style.copyWith(
                color: const Color(0xCCFFFFFF),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: Color(0x66FFFFFF),
        shape: BoxShape.circle,
      ),
    );
  }
}
