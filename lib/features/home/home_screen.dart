import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/format_bytes.dart';
import '../settings/settings_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO(phase-4): read from daily quota + stats providers.
  static const _remaining = 15;
  static const _total = 15;
  static const _freedBytes = 0;
  static const _cleanedCount = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = [
      (Icons.screenshot_outlined, l10n.categoryScreenshots),
      (Icons.videocam_outlined, l10n.categoryVideos),
      (Icons.fiber_manual_record_outlined, l10n.categoryScreenRecordings),
      (Icons.date_range_outlined, l10n.categoryDateRange),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => showSettingsSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _DailyCard(remaining: _remaining, total: _total),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.sd_storage_outlined,
                  label: l10n.homeSpaceFreed,
                  value: formatBytes(_freedBytes),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  icon: Icons.photo_library_outlined,
                  label: l10n.homePhotosCleaned,
                  value: '$_cleanedCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.homeSmartCleanup,
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.3,
            children: [
              for (final (icon, label) in categories)
                _CategoryCard(icon: icon, label: label),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard({required this.remaining, required this.total});

  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeTodaySwipes,
            style: textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$remaining',
            style: textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            l10n.homeSwipesLeft(remaining, total),
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : remaining / total,
              minHeight: 8,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDeep,
            ),
            onPressed: remaining > 0
                ? () => context.push(AppRoutes.swipe)
                : null,
            child: Text(l10n.homeStartSwiping),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: context.palette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Locked until premium (phase 6).
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: context.showComingSoon,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: palette.muted),
                  const Spacer(),
                  _ProBadge(color: palette.premium),
                ],
              ),
              const Spacer(),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            context.l10n.pro,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
