import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'cleanup_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final CleanupResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.theme.textTheme;
    final muted = context.palette.muted;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: context.palette.keep.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 72,
                  color: context.palette.keep,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.resultTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.formatSize(result.bytesFreed),
                style: textTheme.displayMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.resultFreed,
                style: textTheme.titleMedium?.copyWith(color: muted),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.resultDeletedCount(result.photosDeleted),
                style: textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                l10n.resultRestoreHint,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(color: muted),
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
