import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../swipe/swipe_session.dart';

// TODO(phase-3): grid of marked photos + batch delete.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final marked = ref.watch(swipeSessionProvider).value?.toDelete.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.delete_sweep_rounded,
                size: 72,
                color: context.palette.delete,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                marked == 0 ? l10n.reviewEmpty : l10n.swipeMarkedCount(marked),
                textAlign: TextAlign.center,
                style: context.theme.textTheme.titleMedium,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
