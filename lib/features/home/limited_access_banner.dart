import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
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
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: palette.softShadow,
        ),
        child: Row(
          children: [
            IconTile(icon: Icons.photo_library_rounded, color: palette.premium),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                context.l10n.limitedAccessBody,
                style: context.theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: ref.read(galleryServiceProvider).openSettings,
              child: Text(context.l10n.limitedAccessAction),
            ),
          ],
        ),
      ),
    );
  }
}
