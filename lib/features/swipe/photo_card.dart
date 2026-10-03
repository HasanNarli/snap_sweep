import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/config/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/format_bytes.dart';
import '../../shared/widgets/photo_thumbnail.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/gallery_service.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photo, required this.dragPercent});

  final GalleryPhoto photo;

  // -100..100 from the swiper; negative means dragging left (delete).
  final int dragPercent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = (dragPercent.abs() / 100).clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoThumbnail(
              photoId: photo.id,
              size: AppConfig.cardThumbnailSize,
            ),
            const _BottomShade(),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: _PhotoInfo(photo: photo),
            ),
            if (dragPercent < 0)
              Positioned(
                top: AppSpacing.xl,
                right: AppSpacing.lg,
                child: _Stamp(
                  label: context.l10n.swipeDeleteStamp,
                  color: palette.delete,
                  opacity: progress,
                  angle: 0.25,
                ),
              ),
            if (dragPercent > 0)
              Positioned(
                top: AppSpacing.xl,
                left: AppSpacing.lg,
                child: _Stamp(
                  label: context.l10n.swipeKeepStamp,
                  color: palette.keep,
                  opacity: progress,
                  angle: -0.25,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomShade extends StatelessWidget {
  const _BottomShade();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
        ),
      ),
    );
  }
}

class _PhotoInfo extends ConsumerStatefulWidget {
  const _PhotoInfo({required this.photo});

  final GalleryPhoto photo;

  @override
  ConsumerState<_PhotoInfo> createState() => _PhotoInfoState();
}

class _PhotoInfoState extends ConsumerState<_PhotoInfo> {
  late Future<int?> _size;

  @override
  void initState() {
    super.initState();
    _size = _load();
  }

  @override
  void didUpdateWidget(_PhotoInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo != widget.photo) _size = _load();
  }

  Future<int?> _load() =>
      ref.read(galleryServiceProvider).fileSize(widget.photo.id);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMMd(locale).format(widget.photo.createdAt);
    const style = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    return Row(
      children: [
        const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(date, style: style)),
        FutureBuilder(
          future: _size,
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) return const SizedBox.shrink();
            return Text(formatBytes(bytes), style: style);
          },
        ),
      ],
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({
    required this.label,
    required this.color,
    required this.opacity,
    required this.angle,
  });

  final String label;
  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 4),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
