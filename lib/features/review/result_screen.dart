import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import 'cleanup_result.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result});

  final CleanupResult result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final result = widget.result;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              const IconTile(icon: Icons.check_rounded, size: 88, round: true),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.resultTitle, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xl),
              // Counts up to the freed amount.
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: result.bytesFreed.toDouble()),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  final (number, unit) = context.formatSizeParts(value.round());
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        number,
                        style: textTheme.displayLarge?.copyWith(fontSize: 64),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: palette.secondaryLabel,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.resultFreed, style: textTheme.labelMedium),
              Text(
                l10n.resultDeletedCount(result.photosDeleted),
                style: textTheme.labelMedium,
              ),
              const Spacer(),
              Text(
                l10n.resultRestoreHint,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: palette.tertiaryLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
