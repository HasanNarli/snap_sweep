import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (Icons.restore_rounded, l10n.settingsRestore),
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
                  for (final (icon, label) in items)
                    // TODO(phase-6): wire each action.
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
