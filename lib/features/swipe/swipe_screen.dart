import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/round_icon_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(swipeSessionProvider);
    final value = session.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.swipeTitle),
        actions: [
          // Early finish once something is marked.
          if (value != null && !value.isDone && value.toDelete.isNotEmpty)
            TextButton(
              onPressed: () => context.push(AppRoutes.review),
              child: Text(l10n.swipeFinish),
            ),
          if (value != null && value.photos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Text(
                  '${min(value.index + 1, value.photos.length)}/${value.photos.length}',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: switch (session) {
          AsyncData(:final value) when value.photos.isEmpty => _Message(
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
          _ => const Center(child: CircularProgressIndicator()),
        },
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
                backCardOffset: const Offset(0, 24),
                padding: const EdgeInsets.all(AppSpacing.md),
                onSwipe: (_, _, direction) {
                  notifier.decide(
                    delete: direction == CardSwiperDirection.left,
                  );
                  return true;
                },
                onUndo: (_, _, _) {
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
            AppSpacing.sm,
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
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.left),
                    ),
                    RoundIconButton(
                      icon: Icons.undo_rounded,
                      color: palette.muted,
                      tooltip: l10n.swipeUndo,
                      size: 48,
                      onPressed: session.canUndo ? controller.undo : null,
                    ),
                    RoundIconButton(
                      icon: Icons.favorite_rounded,
                      color: palette.keep,
                      tooltip: l10n.swipeKeep,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_rounded,
              size: 72,
              color: context.palette.keep,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.swipeDoneTitle,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.swipeMarkedCount(markedCount),
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: context.palette.muted,
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
        TextButton.icon(
          onPressed: controller.undo,
          icon: const Icon(Icons.undo_rounded),
          label: Text(l10n.swipeUndo),
        ),
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
            Icon(icon, size: 72, color: context.palette.muted),
            const SizedBox(height: AppSpacing.md),
            Text(text, textAlign: TextAlign.center),
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
