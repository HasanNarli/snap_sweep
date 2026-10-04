import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/frosted.dart';
import '../../shared/widgets/grouped_section.dart';
import '../gallery/gallery_access_provider.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _busy = false;

  // Router moves on to home or the permission screen afterwards.
  Future<void> _finish({required bool askAccess}) async {
    setState(() => _busy = true);
    if (askAccess) await ref.read(galleryAccessProvider.notifier).request();
    await ref.read(onboardingDoneProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final features = [
      (
        Icons.swipe_rounded,
        l10n.onboardingTriageTitle,
        l10n.onboardingTriageBody,
      ),
      (Icons.undo_rounded, l10n.onboardingUndoTitle, l10n.onboardingUndoBody),
      (
        Icons.data_usage_rounded,
        l10n.onboardingStorageTitle,
        l10n.onboardingStorageBody,
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
                    const Center(child: _HeroStack()),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.onboardingTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.onboardingSubtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: palette.secondaryLabel,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final (icon, title, body) in features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            IconTile(icon: icon, size: 36, round: true),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: textTheme.titleSmall),
                                  Text(body, style: textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _busy ? null : () => _finish(askAccess: true),
                child: Text(l10n.onboardingAllow),
              ),
              TextButton(
                onPressed: _busy ? null : () => _finish(askAccess: false),
                child: Text(l10n.notNow),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 12,
                      color: palette.secondaryLabel,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.privacyFootnote,
                      style: textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Two framed photos, the back one tilted and faded.
class _HeroStack extends StatelessWidget {
  const _HeroStack();

  // Desaturates the back photo.
  static const _greyscale = ColorFilter.matrix([
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: 260,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-24, 6),
            child: Transform.rotate(
              angle: -0.07,
              child: Opacity(
                opacity: 0.5,
                child: _Frame(
                  width: 176,
                  height: 224,
                  child: Opacity(
                    opacity: 0.6,
                    child: ColorFiltered(
                      colorFilter: _greyscale,
                      child: Image.asset(
                        'assets/images/onboarding_back.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _Frame(
            width: 192,
            height: 240,
            padding: 7,
            shadow: [
              BoxShadow(
                color: palette.label.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: -15,
                offset: const Offset(0, 20),
              ),
            ],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/onboarding_front.jpg',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Frosted(
                      tint: palette.photoGlassLight,
                      blur: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      child: Text(
                        '8.4 MB',
                        style: TextStyle(
                          color: palette.onPhotoGlassLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.width,
    required this.height,
    required this.child,
    this.padding = 1,
    this.shadow,
  });

  final double width;
  final double height;
  final double padding;
  final Widget child;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
        boxShadow: shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
