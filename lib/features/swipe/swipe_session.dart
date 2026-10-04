import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/gallery_service.dart';
import '../quota/daily_quota.dart';

@immutable
class SwipeDecision {
  const SwipeDecision(this.photo, {required this.delete});

  final GalleryPhoto photo;
  final bool delete;
}

@immutable
class SwipeSession {
  const SwipeSession({
    required this.photos,
    this.decisions = const [],
    this.quotaExhausted = false,
  });

  final List<GalleryPhoto> photos;
  final List<SwipeDecision> decisions;

  // No swipes left today; nothing was loaded.
  final bool quotaExhausted;

  int get index => decisions.length;
  bool get isDone => index >= photos.length;
  bool get canUndo => decisions.isNotEmpty;
  List<GalleryPhoto> get toDelete => [
    for (final decision in decisions)
      if (decision.delete) decision.photo,
  ];

  SwipeSession withDecisions(List<SwipeDecision> decisions) =>
      SwipeSession(photos: photos, decisions: decisions);
}

// Auto-disposed: leaving the swipe flow starts a fresh session next time.
final swipeSessionProvider =
    AsyncNotifierProvider.autoDispose<SwipeSessionNotifier, SwipeSession>(
      SwipeSessionNotifier.new,
    );

class SwipeSessionNotifier extends AsyncNotifier<SwipeSession> {
  @override
  Future<SwipeSession> build() async {
    // Batch size is whatever is left of today's quota.
    ref.read(dailyQuotaProvider.notifier).ensureToday();
    final remaining = ref.read(dailyQuotaProvider).remaining;
    if (remaining == 0) {
      return const SwipeSession(photos: [], quotaExhausted: true);
    }

    final photos = await ref
        .read(galleryServiceProvider)
        .randomPhotos(min(remaining, AppConfig.freeDailySwipes));
    final session = SwipeSession(photos: photos);
    _prefetch(session);
    return session;
  }

  // Warms the thumbnail cache for the top card and the next few.
  void _prefetch(SwipeSession session) {
    final gallery = ref.read(galleryServiceProvider);
    final end = min(
      session.index + AppConfig.prefetchAhead + 1,
      session.photos.length,
    );
    for (final photo in session.photos.sublist(session.index, end)) {
      gallery.thumbnail(photo.id, AppConfig.cardThumbnailSize).ignore();
    }
  }

  void decide({required bool delete}) {
    final session = state.value;
    if (session == null || session.isDone) return;
    ref.read(dailyQuotaProvider.notifier).consume();
    final photo = session.photos[session.index];
    final next = session.withDecisions([
      ...session.decisions,
      SwipeDecision(photo, delete: delete),
    ]);
    state = AsyncData(next);
    _prefetch(next);
  }

  void undo() {
    final session = state.value;
    if (session == null || !session.canUndo) return;
    ref.read(dailyQuotaProvider.notifier).refund();
    state = AsyncData(
      session.withDecisions(
        session.decisions.sublist(0, session.decisions.length - 1),
      ),
    );
  }
}
