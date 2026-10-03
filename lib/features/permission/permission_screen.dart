import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/grouped_section.dart';
import '../gallery/gallery_access_provider.dart';
import '../gallery/gallery_service.dart';

// Shown while gallery access is denied; router leaves it once granted.
class PermissionScreen extends ConsumerWidget {
  const PermissionScreen({super.key});

  Future<void> _allow(WidgetRef ref) async {
    final access = await ref.read(galleryAccessProvider.notifier).request();
    // Permanently denied: the system won't prompt again.
    if (!access.canBrowse) {
      await ref.read(galleryServiceProvider).openSettings();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              IconTile(
                icon: Icons.photo_library_rounded,
                color: context.palette.accent,
                size: 96,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.permissionTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.permissionBody,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: context.palette.secondaryLabel,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _allow(ref),
                child: Text(l10n.permissionAllow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
