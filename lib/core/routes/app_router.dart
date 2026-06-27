import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_navigator_keys.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: AppNavigatorKeys.root,

  initialLocation: RouteNames.splash,

  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: RouteNames.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
