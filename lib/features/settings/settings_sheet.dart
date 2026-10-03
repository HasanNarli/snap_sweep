import 'package:flutter/material.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final items = [
      (Icons.restore_rounded, AppColors.tileBlue, l10n.settingsRestore),
      (Icons.privacy_tip_rounded, palette.keep, l10n.settingsPrivacy),
      (Icons.star_rounded, AppColors.tileOrange, l10n.settingsRate),
      (Icons.mail_rounded, AppColors.tilePurple, l10n.settingsContact),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
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
                for (final (icon, color, label) in items)
                  // TODO(phase-6): wire each action.
                  GroupedRow(
                    icon: icon,
                    iconColor: color,
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
    );
  }
}
