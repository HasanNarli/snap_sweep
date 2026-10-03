import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../gallery/gallery_access_provider.dart';
import '../gallery/gallery_service.dart';

// Nudges users with partial access (iOS selected photos, Android 14+).
class LimitedAccessBanner extends ConsumerWidget {
  const LimitedAccessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(galleryAccessProvider) != GalleryAccess.limited) {
      return const SizedBox.shrink();
    }
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: palette.accentSoft,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: palette.border.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: palette.accent),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.limitedAccessBody,
                style: context.theme.textTheme.labelMedium?.copyWith(
                  color: palette.accent,
                ),
              ),
            ),
            TextButton(
              onPressed: ref.read(galleryServiceProvider).openSettings,
              child: Text(
                context.l10n.limitedAccessAction,
                style: TextStyle(color: palette.label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
