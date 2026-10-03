import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gallery/gallery_access_provider.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_provider.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/permission/permission_screen.dart';
import '../../features/review/cleanup_result.dart';
import '../../features/review/result_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/swipe/swipe_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const permission = '/permission';
  static const home = '/';
  static const swipe = '/swipe';
  static const review = '/review';
  static const result = '/result';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run redirect whenever onboarding or gallery access changes.
  final refresh = ValueNotifier(0);
  ref.listen(onboardingDoneProvider, (_, _) => refresh.value++);
  ref.listen(galleryAccessProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (!ref.read(onboardingDoneProvider)) {
        return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }
      if (!ref.read(galleryAccessProvider).canBrowse) {
        return location == AppRoutes.permission ? null : AppRoutes.permission;
      }
      if (location == AppRoutes.onboarding ||
          location == AppRoutes.permission) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.permission,
        builder: (context, state) => const PermissionScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.swipe,
        builder: (context, state) => const SwipeScreen(),
      ),
      GoRoute(
        path: AppRoutes.review,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        // Result only exists right after a cleanup; otherwise go home.
        redirect: (context, state) =>
            state.extra is CleanupResult ? null : AppRoutes.home,
        builder: (context, state) =>
            ResultScreen(result: state.extra! as CleanupResult),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
