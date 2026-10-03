import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../gallery/gallery_access_provider.dart';
import 'onboarding_provider.dart';

// Single "Welcome" page, Apple first-launch style.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _busy = false;

  // Router redirects to home or the permission screen afterwards.
  Future<void> _continue() async {
    setState(() => _busy = true);
    await ref.read(galleryAccessProvider.notifier).request();
    await ref.read(onboardingDoneProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final features = [
      (
        Icons.swipe_rounded,
        palette.accent,
        l10n.onboardingSwipeTitle,
        l10n.onboardingSwipeBody,
      ),
      (
        Icons.undo_rounded,
        palette.premium,
        l10n.onboardingReviewTitle,
        l10n.onboardingReviewBody,
      ),
      (
        Icons.lock_rounded,
        palette.keep,
        l10n.onboardingPrivacyTitle,
        l10n.onboardingPrivacyBody,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: AppSpacing.xl),
                  children: [
                    const Center(child: _SwipeDemo()),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    for (final (icon, color, title, body) in features)
                      _FeatureRow(
                        icon: icon,
                        color: color,
                        title: title,
                        body: body,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: FilledButton(
                  onPressed: _busy ? null : _continue,
                  child: Text(l10n.continueAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
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
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: icon, color: color, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: textTheme.bodyMedium?.copyWith(
                    color: context.palette.secondaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Looping hint: a card tilting left and right over a second card.
class _SwipeDemo extends StatefulWidget {
  const _SwipeDemo();

  @override
  State<_SwipeDemo> createState() => _SwipeDemoState();
}

class _SwipeDemoState extends State<_SwipeDemo>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  // Respect the system "reduce motion" setting.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: 220,
      height: 250,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final swing = sin(_controller.value * 2 * pi);
          final hint = swing.abs();
          final color = swing < 0 ? palette.delete : palette.keep;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, 14),
                child: Transform.scale(
                  scale: 0.92,
                  child: const _DemoCard(
                    colors: [Color(0xFFFFB199), Color(0xFFFF7EB3)],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(swing * 36, 0),
                child: Transform.rotate(
                  angle: swing * 0.14,
                  child: _DemoCard(
                    colors: const [Color(0xFF7DD3FC), Color(0xFF6366F1)],
                    overlay: color.withValues(alpha: hint * 0.35),
                    icon: swing < 0
                        ? Icons.delete_rounded
                        : Icons.favorite_rounded,
                    iconOpacity: hint,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.colors,
    this.overlay,
    this.icon,
    this.iconOpacity = 0,
  });

  final List<Color> colors;
  final Color? overlay;
  final IconData? icon;
  final double iconOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: context.palette.softShadow,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: overlay,
      ),
      child: icon == null
          ? null
          : Opacity(
              opacity: iconOpacity,
              child: Icon(icon, color: Colors.white, size: 56),
            ),
    );
  }
}
