import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock.dart';
import '../../core/config/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../premium/paywall_sheet.dart';

Future<void> showOutOfSwipesSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _OutOfSwipesSheet(),
  );
}

// Shown when today's free swipes are used up.
class _OutOfSwipesSheet extends ConsumerWidget {
  const _OutOfSwipesSheet();

  // TODO(phase-6): rewarded ad (+10, max 2/day).
  void _later(BuildContext context) {
    Navigator.of(context).pop();
    context.showComingSoon();
  }

  void _goPro(BuildContext context) {
    final navigator = Navigator.of(context)..pop();
    showPaywall(navigator.context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final reset = untilMidnight(ref.read(clockProvider)());

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const IconTile(
                icon: Icons.hourglass_bottom_rounded,
                size: 64,
                round: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.outOfSwipesTitle, style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.outOfSwipesBody(reset.inHours, reset.inMinutes % 60),
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => _later(context),
                icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                label: Text(l10n.outOfSwipesWatchAd(AppConfig.rewardedAdBonus)),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  foregroundColor: palette.label,
                  side: BorderSide(color: palette.border),
                  shape: const StadiumBorder(),
                  textStyle: textTheme.labelLarge,
                ),
                onPressed: () => _goPro(context),
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: palette.accent,
                ),
                label: Text(l10n.outOfSwipesGoPro),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.notNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
