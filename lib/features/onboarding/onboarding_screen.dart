import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TODO(phase-1): request gallery permission here.
  void _finish() => context.go(AppRoutes.home);

  void _next(int pageCount) {
    if (_page == pageCount - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final pages = [
      _OnboardingPage(
        icon: Icons.swipe_rounded,
        color: AppColors.primary,
        title: l10n.onboardingSwipeTitle,
        body: l10n.onboardingSwipeBody,
      ),
      _OnboardingPage(
        icon: Icons.undo_rounded,
        color: palette.delete,
        title: l10n.onboardingReviewTitle,
        body: l10n.onboardingReviewBody,
      ),
      _OnboardingPage(
        icon: Icons.lock_rounded,
        color: palette.keep,
        title: l10n.onboardingPrivacyTitle,
        body: l10n.onboardingPrivacyBody,
      ),
    ];
    final isLast = _page == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: AnimatedOpacity(
                  opacity: isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLast ? null : _finish,
                    child: Text(l10n.skip),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                children: pages,
              ),
            ),
            _PageDots(count: pages.length, current: _page),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                onPressed: () => _next(pages.length),
                child: Text(isLast ? l10n.onboardingAllowAccess : l10n.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 84, color: color),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            body,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: context.palette.muted),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: i == current ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == current ? AppColors.primary : context.palette.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
