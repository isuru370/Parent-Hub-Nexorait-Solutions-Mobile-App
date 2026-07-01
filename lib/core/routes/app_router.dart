import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/exams/presentation/pages/exams_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
// ============================================
// 🚀 NOTIFICATION PAGES
// ============================================
import '../../features/notification/presentation/pages/notification_details_page.dart';
import '../../features/notification/presentation/pages/notification_list_page.dart';
import '../../features/payments/presentation/pages/payments_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/results/presentation/pages/result_page.dart';
import '../../features/schedules/presentation/pages/schedules_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/teachers/presentation/pages/teachers_page.dart';
import 'app_navigator_keys.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: AppNavigatorKeys.globalNavigatorKey,
  initialLocation: RouteNames.splash,

  errorBuilder: (context, state) =>
      const Scaffold(body: Center(child: Text('Page not found'))),

  routes: [
    // =========================================================
    // SPLASH & AUTH
    // =========================================================
    GoRoute(path: RouteNames.splash, builder: (_, __) => const SplashPage()),
    GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),

    // =========================================================
    // MAIN DASHBOARD
    // =========================================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardPage(navigationShell: navigationShell);
      },
      branches: [
        // HOME BRANCH
        StatefulShellBranch(
          navigatorKey: AppNavigatorKeys.home,
          routes: [
            GoRoute(
              path: RouteNames.dashboard,
              builder: (_, __) => const HomePage(),
              routes: [
                GoRoute(
                  path: RouteNames.exam,
                  name: 'exam',
                  builder: (_, __) => const ExamsPage(),
                  routes: [
                    GoRoute(
                      path: RouteNames.result,
                      name: 'result',
                      builder: (context, state) {
                        final data = state.extra as Map<String, dynamic>?;

                        if (data == null) {
                          return const Scaffold(
                            body: Center(child: Text('Result data not found')),
                          );
                        }

                        return ResultPage(
                          examId: data['exam_id'] ?? 0,
                          examTitle: data['exam_title'] ?? 'Result',
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: RouteNames.schedule,
                  name: 'schedule',
                  builder: (_, __) => const SchedulesPage(),
                ),
              ],
            ),
          ],
        ),

        // ATTENDANCE BRANCH
        StatefulShellBranch(
          navigatorKey: AppNavigatorKeys.attendance,
          routes: [
            GoRoute(
              path: RouteNames.attendance,
              builder: (_, __) => const AttendancePage(),
            ),
          ],
        ),

        // PAYMENTS BRANCH
        StatefulShellBranch(
          navigatorKey: AppNavigatorKeys.payments,
          routes: [
            GoRoute(
              path: RouteNames.payments,
              builder: (_, __) => const PaymentsPage(),
            ),
          ],
        ),

        // PROFILE BRANCH
        StatefulShellBranch(
          navigatorKey: AppNavigatorKeys.profile,
          routes: [
            GoRoute(
              path: RouteNames.profile,
              builder: (_, __) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: RouteNames.changePassword,
                  name: 'changePassword',
                  builder: (_, __) => const ChangePasswordPage(),
                ),
              ],
            ),
          ],
        ),

        // TEACHERS BRANCH
        StatefulShellBranch(
          navigatorKey: AppNavigatorKeys.teachers,
          routes: [
            GoRoute(
              path: RouteNames.teachers,
              builder: (_, __) => const TeachersPage(),
            ),
          ],
        ),
      ],
    ),

    // =========================================================
    // 🚀 NOTIFICATION ROUTES
    // =========================================================

    // Notification List Page
    GoRoute(
      path: RouteNames.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationListPage(),
    ),

    // Notification Details Page (Single Page for ALL Types)
    GoRoute(
      path: RouteNames.notificationDetails,
      name: 'notificationDetails',
      builder: (context, state) {
        // Get notification_id from query parameters or extra
        final notificationId = state.uri.queryParameters['notification_id'];
        final data = state.extra as Map<String, dynamic>?;

        return NotificationDetailsPage(
          notificationId:
              int.tryParse(
                notificationId ?? data?['notification_id']?.toString() ?? '0',
              ) ??
              0,
          type: data?['type'] ?? 'general',
          title: data?['title'] ?? '',
          body: data?['body'] ?? '',
        );
      },
    ),
  ],
);

// ============================================
// 🚀 NAVIGATION HELPER
// ============================================
class NavigationHelper {
  static void navigateToNotificationDetails(
    BuildContext context, {
    required int notificationId,
    String type = 'general',
    String title = '',
    String body = '',
  }) {
    context.push(
      RouteNames.notificationDetails,
      extra: {
        'notification_id': notificationId,
        'type': type,
        'title': title,
        'body': body,
      },
    );
  }

  static void navigateToNotifications(BuildContext context) {
    context.push(RouteNames.notifications);
  }

  static void pop(BuildContext context) {
    context.pop();
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
