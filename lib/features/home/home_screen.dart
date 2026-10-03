import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/clock.dart';
import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../quota/daily_quota.dart';
import '../quota/out_of_swipes_sheet.dart';
import '../settings/settings_sheet.dart';
import '../stats/cleanup_stats.dart';
import 'limited_access_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _start(BuildContext context, WidgetRef ref) {
    ref.read(dailyQuotaProvider.notifier).ensureToday();
    if (ref.read(dailyQuotaProvider).isExhausted) {
      showOutOfSwipesSheet(context);
    } else {
      context.push(AppRoutes.swipe);
    }
  }

  String _greeting(BuildContext context, DateTime now) {
    final l10n = context.l10n;
    if (now.hour < 12) return l10n.greetingMorning;
    if (now.hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final now = ref.read(clockProvider)();
    final quota = ref.watch(dailyQuotaProvider);
    final date = DateFormat.MMMMEEEEd(context.localeTag).format(now);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date.toUpperCase(),
                          style: textTheme.labelMedium?.copyWith(
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _greeting(context, now),
                          style: textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  RoundIconButton(
                    icon: Icons.tune_rounded,
                    color: palette.label,
                    tooltip: l10n.settingsTitle,
                    size: 36,
                    iconSize: 17,
                    onPressed: () => showSettingsSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const LimitedAccessBanner(),
            _StorageCard(stats: ref.watch(cleanupStatsProvider)),
            const SizedBox(height: AppSpacing.lg),
            _DailySessionCard(
              remaining: quota.remaining,
              total: quota.limit,
              now: now,
              onStart: () => _start(context, ref),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SmartCategories(),
            const SizedBox(height: AppSpacing.lg),
            const _ProCard(),
          ],
        ),
      ),
    );
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.stats});

  final CleanupStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final (number, unit) = context.formatSizeParts(stats.bytesFreed);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: palette.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeStorageReclaimed.toUpperCase(),
                      style: textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(number, style: textTheme.displayLarge),
                        const SizedBox(width: 6),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: palette.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (stats.bytesThisWeek > 0)
                _TrendChip(
                  text: l10n.homeThisWeek(
                    context.formatSize(stats.bytesThisWeek),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: palette.border.withValues(alpha: 0.7)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _Metric(
                label: l10n.homeCleaned,
                value: l10n.homeCleanedValue(stats.photosDeleted),
              ),
              _Metric(label: l10n.homeSessions, value: '${stats.sessions}'),
              _Metric(
                label: l10n.homeAverageSize,
                value: stats.averagePhotoBytes == 0
                    ? '—'
                    : context.formatSize(stats.averagePhotoBytes),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: palette.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up_rounded, size: 14, color: palette.accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: TextStyle(
              color: palette.accent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium?.copyWith(fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _DailySessionCard extends StatelessWidget {
  const _DailySessionCard({
    required this.remaining,
    required this.total,
    required this.now,
    required this.onStart,
  });

  final int remaining;
  final int total;
  final DateTime now;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final untilReset = untilMidnight(now);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.page),
      decoration: palette.card(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: palette.keep,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.homeDailySession, style: textTheme.labelMedium),
              const Spacer(),
              Text(
                l10n.homeResetsIn(
                  untilReset.inHours,
                  untilReset.inMinutes % 60,
                ),
                style: textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeReviewsAvailable(remaining),
                  style: textTheme.labelMedium?.copyWith(color: palette.label),
                ),
              ),
              Text(
                '$remaining / $total',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : remaining / total,
              minHeight: 6,
              color: palette.cta,
              backgroundColor: palette.track,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _StartButton(remaining: remaining, onPressed: onStart),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.remaining, required this.onPressed});

  final int remaining;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final soft = palette.onCta.withValues(alpha: 0.75);

    return Material(
      color: onPressed == null ? palette.track : palette.cta,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.page,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 18, color: soft),
              const SizedBox(width: 10),
              Text(
                l10n.homeStartCleaning,
                style: TextStyle(
                  color: palette.onCta,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Text(
                remaining == 0 ? l10n.homeGetMore : l10n.homeBatchOf(remaining),
                style: TextStyle(
                  color: soft,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.arrow_forward_rounded, size: 15, color: soft),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartCategories extends StatelessWidget {
  const _SmartCategories();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // TODO(phase-6): real item counts and sizes per category.
    final premium = [
      (
        Icons.smartphone_rounded,
        l10n.categoryScreenshots,
        l10n.categoryScreenshotsHint,
      ),
      (Icons.movie_outlined, l10n.categoryVideos, l10n.categoryVideosHint),
      (
        Icons.radio_button_checked_rounded,
        l10n.categoryScreenRecordings,
        l10n.categoryScreenRecordingsHint,
      ),
      (
        Icons.calendar_month_outlined,
        l10n.categoryDateRange,
        l10n.categoryDateRangeHint,
      ),
    ];
    final upcoming = [
      (
        Icons.burst_mode_outlined,
        l10n.categoryDuplicates,
        l10n.categoryDuplicatesHint,
      ),
      (Icons.blur_on_rounded, l10n.categoryBlurry, l10n.categoryBlurryHint),
    ];

    return GroupedSection(
      header: l10n.homeSmartCategories,
      children: [
        for (final (icon, title, hint) in premium)
          GroupedRow(
            icon: icon,
            title: title,
            subtitle: hint,
            badge: TagLabel(text: l10n.pro),
            locked: true,
            onTap: context.showComingSoon,
          ),
        for (final (icon, title, hint) in upcoming)
          GroupedRow(
            icon: icon,
            title: title,
            subtitle: hint,
            badge: TagLabel(text: l10n.soon),
            enabled: false,
          ),
      ],
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.fill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.proCardTitle,
                  style: textTheme.titleSmall?.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(l10n.proCardBody, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // TODO(phase-6): open the paywall.
          Material(
            color: palette.surface,
            shape: StadiumBorder(side: BorderSide(color: palette.border)),
            child: InkWell(
              onTap: context.showComingSoon,
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7,
                ),
                child: Text(
                  l10n.upgrade,
                  style: textTheme.titleSmall?.copyWith(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
