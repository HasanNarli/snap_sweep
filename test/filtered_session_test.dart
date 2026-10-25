import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/filters/media_filter.dart';
import 'package:snap_sweep/features/gallery/gallery_photo.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/features/quota/daily_quota.dart';
import 'package:snap_sweep/features/swipe/swipe_session.dart';

import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late FakeGalleryService gallery;

  setUp(() async {
    gallery = FakeGalleryService(access: GalleryAccess.granted)
      ..categories[MediaCategory.screenshots] = [
        for (var i = 0; i < 120; i++)
          GalleryPhoto(id: 'shot-$i', createdAt: DateTime(2025, 1, 1 + i % 28)),
      ];
    container = ProviderContainer(
      overrides: await testOverrides(gallery: gallery),
    );
    container
      ..read(swipeFilterProvider.notifier)
          .select(const MediaFilter(MediaCategory.screenshots))
      ..listen(swipeSessionProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  SwipeSession session() => container.read(swipeSessionProvider).requireValue;
  SwipeSessionNotifier notifier() =>
      container.read(swipeSessionProvider.notifier);

  test('loads the first page and knows the category size', () async {
    await container.read(swipeSessionProvider.future);
    expect(session().photos, hasLength(50));
    expect(session().total, 120);
    expect(session().hasMore, isTrue);
  });

  test('does not use the daily quota', () async {
    await container.read(swipeSessionProvider.future);
    for (var i = 0; i < 20; i++) {
      notifier().decide(delete: i.isEven);
    }
    expect(container.read(dailyQuotaProvider).used, 0);
  });

  test('loads the next page before running out', () async {
    await container.read(swipeSessionProvider.future);
    for (var i = 0; i < 40; i++) {
      notifier().decide(delete: false);
    }
    await pumpEventQueue();
    expect(gallery.pageRequests, ['0+50', '50+50']);
    expect(session().photos, hasLength(100));
  });

  test('finishes only after the whole category', () async {
    await container.read(swipeSessionProvider.future);
    for (var i = 0; i < 120; i++) {
      notifier().decide(delete: i < 3);
      await pumpEventQueue();
    }
    expect(session().isDone, isTrue);
    expect(session().toDelete.map((p) => p.id), ['shot-0', 'shot-1', 'shot-2']);
  });
}
