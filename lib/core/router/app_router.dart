import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/swipe/swipe_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const swipe = '/swipe';
  static const review = '/review';
}

// TODO(phase-1): redirect based on onboarding + permission state.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
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
    ],
  );
});
