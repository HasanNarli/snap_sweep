import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/gallery_service.dart';

@immutable
class SwipeDecision {
  const SwipeDecision(this.photo, {required this.delete});

  final GalleryPhoto photo;
  final bool delete;
}

@immutable
class SwipeSession {
  const SwipeSession({required this.photos, this.decisions = const []});

  final List<GalleryPhoto> photos;
  final List<SwipeDecision> decisions;

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
    // TODO(phase-4): use the remaining daily quota instead of the full limit.
    final photos = await ref
        .read(galleryServiceProvider)
        .randomPhotos(AppConfig.freeDailySwipes);
    return SwipeSession(photos: photos);
  }

  void decide({required bool delete}) {
    final session = state.value;
    if (session == null || session.isDone) return;
    final photo = session.photos[session.index];
    state = AsyncData(
      session.withDecisions([
        ...session.decisions,
        SwipeDecision(photo, delete: delete),
      ]),
    );
  }

  void undo() {
    final session = state.value;
    if (session == null || !session.canUndo) return;
    state = AsyncData(
      session.withDecisions(
        session.decisions.sublist(0, session.decisions.length - 1),
      ),
    );
  }
}
