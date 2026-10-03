import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/round_icon_button.dart';

// TODO(phase-2): real card stack with random photos.
class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.swipeTitle),
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.review),
            child: Text(l10n.swipeFinish),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 72,
                          color: palette.muted,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.comingSoon,
                          style: TextStyle(color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundIconButton(
                    icon: Icons.close_rounded,
                    color: palette.delete,
                    tooltip: l10n.swipeDelete,
                    onPressed: () {},
                  ),
                  RoundIconButton(
                    icon: Icons.undo_rounded,
                    color: palette.muted,
                    tooltip: l10n.swipeUndo,
                    size: 48,
                    onPressed: () {},
                  ),
                  RoundIconButton(
                    icon: Icons.favorite_rounded,
                    color: palette.keep,
                    tooltip: l10n.swipeKeep,
                    onPressed: () {},
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
