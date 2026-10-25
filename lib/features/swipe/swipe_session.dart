import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../filters/media_filter.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/gallery_service.dart';
import '../premium/premium_provider.dart';
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
    this.filter,
    this.knownTotal,
  });

  // Loaded so far; filtered sessions grow page by page.
  final List<GalleryPhoto> photos;
  final List<SwipeDecision> decisions;

  // No swipes left today; nothing was loaded.
  final bool quotaExhausted;

  // Premium category being cleaned; null for the free daily mix.
  final MediaFilter? filter;
  // Category size; null when every photo is loaded up front.
  final int? knownTotal;

  int get total => knownTotal ?? photos.length;
  bool get hasMore => photos.length < total;
  int get index => decisions.length;
  bool get isDone => index >= photos.length && !hasMore;
  bool get canUndo => decisions.isNotEmpty;
  List<GalleryPhoto> get toDelete => [
    for (final decision in decisions)
      if (decision.delete) decision.photo,
  ];

  SwipeSession copyWith({
    List<GalleryPhoto>? photos,
    List<SwipeDecision>? decisions,
  }) => SwipeSession(
    photos: photos ?? this.photos,
    decisions: decisions ?? this.decisions,
    filter: filter,
    knownTotal: knownTotal,
  );
}

// Category for the next swipe session; null starts the free daily mix.
final swipeFilterProvider = NotifierProvider<SwipeFilterNotifier, MediaFilter?>(
  SwipeFilterNotifier.new,
);

class SwipeFilterNotifier extends Notifier<MediaFilter?> {
  @override
  MediaFilter? build() => null;

  void select(MediaFilter? filter) => state = filter;
}

// Auto-disposed: leaving the swipe flow starts a fresh session next time.
final swipeSessionProvider =
    AsyncNotifierProvider.autoDispose<SwipeSessionNotifier, SwipeSession>(
      SwipeSessionNotifier.new,
    );

class SwipeSessionNotifier extends AsyncNotifier<SwipeSession> {
  // Filtered sessions load this many at a time, the next page early.
  static const pageSize = 50;
  static const loadAheadThreshold = 10;

  bool _loadingMore = false;
  bool _unlimited = false;

  bool _countsQuota(SwipeSession session) =>
      session.filter == null && !_unlimited;

  @override
  Future<SwipeSession> build() async {
    final filter = ref.read(swipeFilterProvider);
    if (filter != null) {
      // Premium: the whole category, no daily quota.
      final gallery = ref.read(galleryServiceProvider);
      final total = await gallery.count(filter);
      final photos = await gallery.page(filter, start: 0, size: pageSize);
      final session = SwipeSession(
        photos: photos,
        filter: filter,
        knownTotal: total,
      );
      _prefetch(session);
      return session;
    }

    // Batch size is whatever is left of today's quota; Pro has no quota.
    _unlimited = ref.read(premiumProvider);
    ref.read(dailyQuotaProvider.notifier).ensureToday();
    final remaining = _unlimited
        ? AppConfig.freeDailySwipes
        : ref.read(dailyQuotaProvider).remaining;
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

  Future<void> _loadMoreIfNeeded(SwipeSession session) async {
    final filter = session.filter;
    if (filter == null || !session.hasMore || _loadingMore) return;
    if (session.photos.length - session.index > loadAheadThreshold) return;

    _loadingMore = true;
    try {
      final more = await ref
          .read(galleryServiceProvider)
          .page(filter, start: session.photos.length, size: pageSize);
      final current = state.value;
      if (current == null || current.filter != filter) return;
      state = AsyncData(
        more.isEmpty
            // Gallery shrank under us; stop where we are.
            ? SwipeSession(
                photos: current.photos,
                decisions: current.decisions,
                filter: filter,
                knownTotal: current.photos.length,
              )
            : current.copyWith(photos: [...current.photos, ...more]),
      );
    } finally {
      _loadingMore = false;
    }
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
    if (session == null || session.index >= session.photos.length) return;
    if (_countsQuota(session)) ref.read(dailyQuotaProvider.notifier).consume();
    final photo = session.photos[session.index];
    final next = session.copyWith(
      decisions: [
        ...session.decisions,
        SwipeDecision(photo, delete: delete),
      ],
    );
    state = AsyncData(next);
    _prefetch(next);
    _loadMoreIfNeeded(next);
  }

  void undo() {
    final session = state.value;
    if (session == null || !session.canUndo) return;
    if (_countsQuota(session)) ref.read(dailyQuotaProvider.notifier).refund();
    state = AsyncData(
      session.copyWith(
        decisions: session.decisions.sublist(0, session.decisions.length - 1),
      ),
    );
  }
}
