import 'dart:math';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/photo_thumbnail.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../../shared/widgets/segmented_progress.dart';
import 'photo_card.dart';
import 'swipe_session.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  final _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.home);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final session = ref.watch(swipeSessionProvider);
    final value = session.value;
    final current = value != null && !value.isDone && value.photos.isNotEmpty
        ? value.photos[value.index]
        : null;

    return Scaffold(
      body: Stack(
        children: [
          // Blurred copy of the current photo, Apple Music style.
          Positioned.fill(child: _Backdrop(photoId: current?.id)),
          SafeArea(
            child: Column(
              children: [
                _TopBar(session: value, onClose: _close),
                Expanded(
                  child: switch (session) {
                    AsyncData(:final value) when value.photos.isEmpty =>
                      _Message(
                        icon: Icons.photo_library_outlined,
                        text: l10n.swipeNoPhotos,
                      ),
                    AsyncData(:final value) => _SwipeBody(
                      session: value,
                      controller: _controller,
                    ),
                    AsyncError() => _Message(
                      icon: Icons.error_outline_rounded,
                      text: l10n.swipeLoadError,
                      action: TextButton(
                        onPressed: () => ref.invalidate(swipeSessionProvider),
                        child: Text(l10n.retry),
                      ),
                    ),
                    _ => Center(
                      child: CircularProgressIndicator(
                        color: palette.secondaryLabel,
                      ),
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.photoId});

  final String? photoId;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: palette.background),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: photoId == null
              ? const SizedBox.expand()
              : ImageFiltered(
                  key: ValueKey(photoId),
                  imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: PhotoThumbnail(photoId: photoId!, size: 64),
                ),
        ),
        ColoredBox(color: palette.background.withValues(alpha: 0.6)),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.session, required this.onClose});

  final SwipeSession? session;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final s = session;
    final total = s?.photos.length ?? 0;
    final canFinish = s != null && !s.isDone && s.toDelete.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              RoundIconButton(
                icon: Icons.close_rounded,
                color: palette.label,
                background: palette.fill.withValues(alpha: 0.8),
                tooltip: l10n.close,
                size: 40,
                onPressed: onClose,
              ),
              Expanded(
                child: Text(
                  total == 0 ? '' : '${min(s!.index + 1, total)} / $total',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.titleSmall,
                ),
              ),
              SizedBox(
                width: 72,
                child: canFinish
                    // Early finish once something is marked.
                    ? TextButton(
                        onPressed: () => context.push(AppRoutes.review),
                        child: Text(l10n.swipeFinish),
                      )
                    : null,
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: AppSpacing.md),
            SegmentedProgress(
              count: total,
              done: s!.index,
              color: palette.label,
              trackColor: palette.label.withValues(alpha: 0.12),
            ),
          ],
        ],
      ),
    );
  }
}

class _SwipeBody extends ConsumerWidget {
  const _SwipeBody({required this.session, required this.controller});

  final SwipeSession session;
  final CardSwiperController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final notifier = ref.read(swipeSessionProvider.notifier);
    final count = session.photos.length;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              if (session.isDone)
                _DoneView(markedCount: session.toDelete.length),
              // Kept mounted after the last card so undo still works.
              CardSwiper(
                controller: controller,
                cardsCount: count,
                initialIndex: min(session.index, count - 1),
                numberOfCardsDisplayed: min(2, count),
                isLoop: false,
                allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                  horizontal: true,
                ),
                backCardOffset: const Offset(0, 16),
                scale: 0.94,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                onSwipe: (_, _, direction) {
                  final delete = direction == CardSwiperDirection.left;
                  delete
                      ? HapticFeedback.mediumImpact()
                      : HapticFeedback.lightImpact();
                  notifier.decide(delete: delete);
                  return true;
                },
                onUndo: (_, _, _) {
                  HapticFeedback.selectionClick();
                  notifier.undo();
                  return true;
                },
                cardBuilder: (context, index, dragPercent, _) => PhotoCard(
                  photo: session.photos[index],
                  dragPercent: dragPercent,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: session.isDone
              ? _DoneActions(session: session, controller: controller)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundIconButton(
                      icon: Icons.close_rounded,
                      color: palette.delete,
                      tooltip: l10n.swipeDelete,
                      size: 68,
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.left),
                    ),
                    RoundIconButton(
                      icon: Icons.undo_rounded,
                      color: palette.secondaryLabel,
                      tooltip: l10n.swipeUndo,
                      size: 48,
                      onPressed: session.canUndo ? controller.undo : null,
                    ),
                    RoundIconButton(
                      icon: Icons.favorite_rounded,
                      color: palette.keep,
                      tooltip: l10n.swipeKeep,
                      size: 68,
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.right),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.markedCount});

  final int markedCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: palette.keep,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.swipeDoneTitle, style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.swipeMarkedCount(markedCount),
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: palette.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneActions extends StatelessWidget {
  const _DoneActions({required this.session, required this.controller});

  final SwipeSession session;
  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final marked = session.toDelete.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton(
          onPressed: () => marked > 0
              ? context.push(AppRoutes.review)
              : context.go(AppRoutes.home),
          child: Text(
            marked > 0 ? l10n.swipeReviewAction(marked) : l10n.backToHome,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(onPressed: controller.undo, child: Text(l10n.swipeUndo)),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: context.palette.secondaryLabel),
            const SizedBox(height: AppSpacing.md),
            Text(
              text,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyLarge,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.sm),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
