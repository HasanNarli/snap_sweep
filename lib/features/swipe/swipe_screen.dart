import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../gallery/gallery_photo.dart';
import '../gallery/photo_size_provider.dart';
import 'photo_card.dart';
import 'swipe_session.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  final _controller = CardSwiperController();
  String? _toast;
  Timer? _toastTimer;

  @override
  void dispose() {
    _toastTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _close() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.home);

  // Brief "Marked • 4.2 MB" feedback after a delete swipe.
  Future<void> _showMarkedToast(GalleryPhoto photo) async {
    final bytes = await ref.read(photoSizeProvider(photo.id).future);
    if (!mounted || bytes == null) return;
    setState(
      () => _toast = context.l10n.swipeMarkedToast(context.formatSize(bytes)),
    );
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(swipeSessionProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(session: session.value, onClose: _close),
            Expanded(
              child: switch (session) {
                AsyncData(:final value) when value.quotaExhausted => _Message(
                  icon: Icons.hourglass_bottom_rounded,
                  text: l10n.outOfSwipesTitle,
                ),
                AsyncData(:final value) when value.photos.isEmpty => _Message(
                  icon: Icons.photo_library_outlined,
                  text: l10n.swipeNoPhotos,
                ),
                AsyncData(:final value) => _SwipeBody(
                  session: value,
                  controller: _controller,
                  toast: _toast,
                  onMarked: _showMarkedToast,
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
          ],
        ),
      ),
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
    final textTheme = context.theme.textTheme;
    final s = session;
    final total = s?.photos.length ?? 0;
    final canFinish = s != null && !s.isDone && s.toDelete.isNotEmpty;

    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Align(
                alignment: Alignment.centerLeft,
                child: RoundIconButton(
                  icon: Icons.close_rounded,
                  color: palette.label,
                  tooltip: l10n.close,
                  size: 40,
                  iconSize: 22,
                  plain: true,
                  onPressed: onClose,
                ),
              ),
            ),
            Expanded(
              child: total == 0
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.swipeCounter(min(s!.index + 1, total), total),
                          style: textTheme.titleSmall,
                        ),
                        Text(
                          l10n.swipeSubtitle,
                          style: textTheme.labelMedium?.copyWith(
                            fontSize: 11,
                            color: palette.tertiaryLabel,
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(
              width: 72,
              child: canFinish
                  // Early finish once something is marked.
                  ? TextButton(
                      onPressed: () => context.push(AppRoutes.review),
                      child: Text(
                        l10n.swipeFinish,
                        style: TextStyle(color: palette.label),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeBody extends ConsumerWidget {
  const _SwipeBody({
    required this.session,
    required this.controller,
    required this.toast,
    required this.onMarked,
  });

  final SwipeSession session;
  final CardSwiperController controller;
  final String? toast;
  final ValueChanged<GalleryPhoto> onMarked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final notifier = ref.read(swipeSessionProvider.notifier);
    final count = session.photos.length;

    // Card, toast and controls stay together as one centered group.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (session.isDone)
                Positioned.fill(
                  child: _DoneView(markedCount: session.toDelete.length),
                ),
              // Kept mounted after the last card so undo still works.
              // 4:5 card as in the design; shrinks on short screens.
              AspectRatio(
                aspectRatio: 4 / 5,
                child: SizedBox.expand(
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: count,
                    initialIndex: min(session.index, count - 1),
                    numberOfCardsDisplayed: min(2, count),
                    isLoop: false,
                    allowedSwipeDirection:
                        const AllowedSwipeDirection.symmetric(horizontal: true),
                    backCardOffset: const Offset(0, 14),
                    scale: 0.95,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.sm,
                      AppSpacing.page,
                      AppSpacing.lg,
                    ),
                    onSwipe: (previous, _, direction) {
                      final delete = direction == CardSwiperDirection.left;
                      if (delete) {
                        HapticFeedback.mediumImpact();
                        onMarked(session.photos[previous]);
                      } else {
                        HapticFeedback.lightImpact();
                      }
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
                ),
              ),
            ],
          ),
        ),
        // "Marked • 4.2 MB" slot between the card and the controls.
        SizedBox(
          height: 28,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: toast == null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Center(child: _Toast(text: toast ?? '')),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: session.isDone
              ? _DoneActions(session: session, controller: controller)
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundIconButton(
                        icon: Icons.delete_outline_rounded,
                        color: palette.delete,
                        tooltip: l10n.swipeDelete,
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.left),
                      ),
                      RoundIconButton(
                        icon: Icons.undo_rounded,
                        color: palette.secondaryLabel,
                        tooltip: l10n.swipeUndo,
                        size: 42,
                        iconSize: 18,
                        onPressed: session.canUndo ? controller.undo : null,
                      ),
                      RoundIconButton(
                        icon: Icons.check_rounded,
                        color: palette.keep,
                        tooltip: l10n.swipeKeep,
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.right),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _Toast extends StatelessWidget {
  const _Toast({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xCC000000),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.27,
          height: 1.5,
        ),
      ),
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
            const IconTile(icon: Icons.check_rounded, size: 72, round: true),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.swipeDoneTitle, style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.swipeMarkedCount(markedCount),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(fontSize: 14),
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
            IconTile(icon: icon, size: 72, round: true),
            const SizedBox(height: AppSpacing.md),
            Text(
              text,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyMedium,
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
