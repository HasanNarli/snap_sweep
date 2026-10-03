import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/activity_ring.dart';
import '../../shared/widgets/grouped_section.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../settings/settings_sheet.dart';
import '../stats/cleanup_stats.dart';
import 'limited_access_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // TODO(phase-4): read from the daily quota provider.
  static const _remaining = 15;
  static const _total = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final stats = ref.watch(cleanupStatsProvider);
    final today = DateFormat.MMMMEEEEd(context.localeTag)
        .format(DateTime.now());
    final categories = [
      (Icons.screenshot_rounded, AppColors.tileBlue, l10n.categoryScreenshots),
      (Icons.videocam_rounded, AppColors.tileOrange, l10n.categoryVideos),
      (
        Icons.radio_button_checked_rounded,
        AppColors.tileRed,
        l10n.categoryScreenRecordings,
      ),
      (
        Icons.calendar_month_rounded,
        AppColors.tilePurple,
        l10n.categoryDateRange,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          children: [
            // Large title header.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(today.toUpperCase(), style: textTheme.labelSmall),
                        const SizedBox(height: 2),
                        Text(l10n.appTitle, style: textTheme.headlineLarge),
                      ],
                    ),
                  ),
                  RoundIconButton(
                    icon: Icons.settings_rounded,
                    color: palette.label,
                    background: palette.fill,
                    tooltip: l10n.settingsTitle,
                    size: 40,
                    onPressed: () => showSettingsSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: ActivityRing(
                progress: _remaining / _total,
                color: palette.accent,
                trackColor: palette.accent.withValues(alpha: 0.12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$_remaining', style: textTheme.displayLarge),
                    Text(
                      l10n.homeSwipesLeftToday,
                      style: textTheme.bodyMedium?.copyWith(
                        color: palette.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _remaining > 0
                  ? () => context.push(AppRoutes.swipe)
                  : null,
              child: Text(l10n.homeStartSwiping),
            ),
            const SizedBox(height: AppSpacing.xl),
            const LimitedAccessBanner(),
            _StatsCard(
              freed: context.formatSize(stats.bytesFreed),
              cleaned: '${stats.photosDeleted}',
            ),
            const SizedBox(height: AppSpacing.xl),
            GroupedSection(
              header: l10n.homeSmartCleanup,
              children: [
                for (final (icon, color, label) in categories)
                  // Locked until premium (phase 6).
                  GroupedRow(
                    icon: icon,
                    iconColor: color,
                    title: label,
                    trailing: CapsuleLabel(
                      text: l10n.pro,
                      color: palette.premium,
                    ),
                    onTap: context.showComingSoon,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.freed, required this.cleaned});

  final String freed;
  final String cleaned;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: palette.softShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _Stat(value: freed, label: l10n.homeSpaceFreed),
            ),
            VerticalDivider(width: 1, thickness: 0.5, color: palette.separator),
            Expanded(
              child: _Stat(value: cleaned, label: l10n.homePhotosCleaned),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
