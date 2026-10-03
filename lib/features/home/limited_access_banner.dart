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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: palette.premium),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(context.l10n.limitedAccessBody)),
              TextButton(
                onPressed: ref.read(galleryServiceProvider).openSettings,
                child: Text(context.l10n.limitedAccessAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
