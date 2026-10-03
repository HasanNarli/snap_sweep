import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../features/gallery/gallery_service.dart';

// Loads a gallery thumbnail by asset id and fills its box.
class PhotoThumbnail extends ConsumerStatefulWidget {
  const PhotoThumbnail({super.key, required this.photoId, required this.size});

  final String photoId;
  final int size;

  @override
  ConsumerState<PhotoThumbnail> createState() => _PhotoThumbnailState();
}

class _PhotoThumbnailState extends ConsumerState<PhotoThumbnail> {
  late Future<Uint8List?> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = _load();
  }

  @override
  void didUpdateWidget(PhotoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoId != widget.photoId || oldWidget.size != widget.size) {
      _bytes = _load();
    }
  }

  Future<Uint8List?> _load() =>
      ref.read(galleryServiceProvider).thumbnail(widget.photoId, widget.size);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bytes,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes != null) {
          return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
        }
        return ColoredBox(
          color: context.palette.border,
          child: snapshot.connectionState == ConnectionState.done
              ? Icon(Icons.broken_image_outlined, color: context.palette.muted)
              : null,
        );
      },
    );
  }
}
