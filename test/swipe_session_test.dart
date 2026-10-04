import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/features/swipe/swipe_session.dart';

import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late FakeGalleryService gallery;

  setUp(() async {
    gallery = FakeGalleryService(access: GalleryAccess.granted, photoCount: 5);
    container = ProviderContainer(
      overrides: await testOverrides(gallery: gallery),
    );
    // Keep the auto-disposed session alive during the test.
    container.listen(swipeSessionProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  SwipeSession session() => container.read(swipeSessionProvider).requireValue;
  SwipeSessionNotifier notifier() =>
      container.read(swipeSessionProvider.notifier);

  test('loads photos and tracks decisions', () async {
    await container.read(swipeSessionProvider.future);
    expect(session().photos, hasLength(5));

    notifier().decide(delete: true);
    notifier().decide(delete: false);
    expect(session().index, 2);
    expect(session().toDelete.map((p) => p.id), ['photo-0']);
  });

  test('undo restores the previous card', () async {
    await container.read(swipeSessionProvider.future);
    notifier().decide(delete: true);
    notifier().undo();

    expect(session().index, 0);
    expect(session().toDelete, isEmpty);
    expect(session().canUndo, isFalse);
  });

  test('ignores decisions after the last card', () async {
    await container.read(swipeSessionProvider.future);
    for (var i = 0; i < 7; i++) {
      notifier().decide(delete: true);
    }
    expect(session().isDone, isTrue);
    expect(session().toDelete, hasLength(5));
  });

  test('prefetches the top card and the next ones', () async {
    await container.read(swipeSessionProvider.future);
    expect(gallery.thumbnailRequests, ['photo-0', 'photo-1', 'photo-2']);

    notifier().decide(delete: false);
    expect(gallery.thumbnailRequests.last, 'photo-3');
  });
}
