import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gallery_service.dart';

// Checked before runApp so the first route is correct; overridden in main().
final initialGalleryAccessProvider = Provider<GalleryAccess>(
  (ref) => GalleryAccess.undetermined,
);

final galleryAccessProvider =
    NotifierProvider<GalleryAccessNotifier, GalleryAccess>(
      GalleryAccessNotifier.new,
    );

class GalleryAccessNotifier extends Notifier<GalleryAccess> {
  @override
  GalleryAccess build() {
    // Re-check when the user comes back from system settings.
    final listener = AppLifecycleListener(onResume: refresh);
    ref.onDispose(listener.dispose);
    return ref.read(initialGalleryAccessProvider);
  }

  Future<void> refresh() async {
    final access = await ref.read(galleryServiceProvider).checkAccess();
    if (ref.mounted) state = access;
  }

  Future<GalleryAccess> request() async {
    final access = await ref.read(galleryServiceProvider).requestAccess();
    if (ref.mounted) state = access;
    return access;
  }
}
