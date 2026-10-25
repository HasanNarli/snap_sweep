import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import 'premium_provider.dart';
import 'purchase_service.dart';

// Returns true when the user ends up with premium.
Future<bool> showPaywall(BuildContext context) async {
  final unlocked = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _PaywallSheet(),
  );
  return unlocked ?? false;
}

class _PaywallSheet extends ConsumerStatefulWidget {
  const _PaywallSheet();

  @override
  ConsumerState<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<_PaywallSheet> {
  PlanKind _selected = PlanKind.yearly;
  bool _busy = false;

  // Runs a store action; closes on premium, else shows [failure] if any.
  Future<void> _run(Future<bool> Function() action, String? failure) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final unlocked = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    if (unlocked) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.purchaseWelcome)));
    } else if (failure != null) {
      messenger.showSnackBar(SnackBar(content: Text(failure)));
    }
  }

  Future<void> _buy(PremiumPlan plan) async {
    final failed = context.l10n.purchaseFailed;
    PurchaseOutcome? outcome;
    await _run(() async {
      outcome = await ref.read(premiumProvider.notifier).buy(plan);
      return outcome == PurchaseOutcome.purchased;
    }, null);
    // Cancelling the store sheet is a choice, not an error.
    if (outcome == PurchaseOutcome.failed && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  void _restore() => _run(
    ref.read(premiumProvider.notifier).restore,
    context.l10n.restoreNone,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.theme.textTheme;
    final plans = ref.watch(premiumPlansProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconTile(
            icon: Icons.workspace_premium_outlined,
            size: 64,
            round: true,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.paywallTitle, style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.paywallSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.lg),
          GroupedSection(
            children: [
              GroupedRow(
                icon: Icons.all_inclusive_rounded,
                title: l10n.paywallUnlimited,
                subtitle: l10n.paywallUnlimitedHint,
              ),
              GroupedRow(
                icon: Icons.grid_view_rounded,
                title: l10n.paywallCategories,
                subtitle: l10n.paywallCategoriesHint,
              ),
              GroupedRow(
                icon: Icons.block_rounded,
                title: l10n.paywallNoAds,
                subtitle: l10n.paywallNoAdsHint,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          switch (plans) {
            AsyncData(:final value) when value.isNotEmpty => _Plans(
              plans: value,
              selected: _selected,
              busy: _busy,
              onSelect: (kind) => setState(() => _selected = kind),
              onBuy: _buy,
            ),
            AsyncData() || AsyncError() => _Unavailable(
              onRetry: () => ref.invalidate(premiumPlansProvider),
            ),
            _ => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
          },
          TextButton(
            onPressed: _busy ? null : _restore,
            child: Text(l10n.settingsRestore),
          ),
        ],
      ),
    );
  }
}

class _Plans extends StatelessWidget {
  const _Plans({
    required this.plans,
    required this.selected,
    required this.busy,
    required this.onSelect,
    required this.onBuy,
  });

  final List<PremiumPlan> plans;
  final PlanKind selected;
  final bool busy;
  final ValueChanged<PlanKind> onSelect;
  final ValueChanged<PremiumPlan> onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final chosen = plans.firstWhere(
      (plan) => plan.kind == selected,
      orElse: () => plans.first,
    );

    return Column(
      children: [
        for (final plan in plans) ...[
          _PlanCard(
            plan: plan,
            selected: plan == chosen,
            onTap: busy ? null : () => onSelect(plan.kind),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xs),
        FilledButton(
          onPressed: busy ? null : () => onBuy(chosen),
          child: busy
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: palette.tertiaryLabel,
                  ),
                )
              : Text(l10n.paywallContinue),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          chosen.kind == PlanKind.yearly
              ? l10n.paywallRenewNote
              : l10n.paywallLifetimeNote,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final PremiumPlan plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final textTheme = context.theme.textTheme;
    final yearly = plan.kind == PlanKind.yearly;
    final perMonth = plan.pricePerMonth;

    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: palette
              .card(radius: AppRadius.md)
              .copyWith(
                border: Border.all(
                  color: selected ? palette.accent : palette.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 22,
                color: selected ? palette.accent : palette.tertiaryLabel,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yearly ? l10n.planYearly : l10n.planLifetime,
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      yearly
                          ? (perMonth == null
                                ? l10n.planYearlyHint
                                : l10n.planPerMonth(perMonth))
                          : l10n.planLifetimeHint,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(plan.price, style: textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Text(
            l10n.paywallUnavailable,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
