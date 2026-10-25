import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../premium/premium_provider.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    final restored = await ref.read(premiumProvider.notifier).restore();
    messenger.showSnackBar(
      SnackBar(content: Text(restored ? l10n.restoreDone : l10n.restoreNone)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = [
      (Icons.privacy_tip_outlined, l10n.settingsPrivacy),
      (Icons.star_outline_rounded, l10n.settingsRate),
      (Icons.mail_outline_rounded, l10n.settingsContact),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            0,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.settingsTitle,
                style: context.theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              GroupedSection(
                children: [
                  GroupedRow(
                    icon: Icons.restore_rounded,
                    title: l10n.settingsRestore,
                    onTap: () => _restore(context, ref),
                  ),
                  for (final (icon, label) in items)
                    // TODO(phase-7): privacy policy, store rating and contact links.
                    GroupedRow(
                      icon: icon,
                      title: label,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.showComingSoon();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
