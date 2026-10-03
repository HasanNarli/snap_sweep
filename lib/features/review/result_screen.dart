import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/activity_ring.dart';
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
              ActivityRing(
                progress: 1,
                color: palette.keep,
                trackColor: palette.keep.withValues(alpha: 0.12),
                size: 180,
                stroke: 18,
                child: Icon(Icons.check_rounded, size: 72, color: palette.keep),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.resultTitle, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              // Counts up to the freed amount.
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: result.bytesFreed.toDouble()),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  context.formatSize(value.round()),
                  style: textTheme.displayMedium,
                ),
              ),
              Text(
                l10n.resultFreed,
                style: textTheme.bodyLarge?.copyWith(
                  color: palette.secondaryLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.resultDeletedCount(result.photosDeleted),
                style: textTheme.bodyLarge?.copyWith(
                  color: palette.secondaryLabel,
                ),
              ),
              const Spacer(),
              Text(
                l10n.resultRestoreHint,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
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
