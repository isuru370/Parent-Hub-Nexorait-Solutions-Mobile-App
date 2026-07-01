// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';

import '../../features/attendance/core/attendance_injection.dart';
import '../../features/auth/core/login_injection.dart' as authDI;
import '../../features/exams/core/exam_injection.dart';
import '../../features/home/core/dashboard_injection.dart';
import '../../features/notification/core/notification_injection.dart';
import '../../features/payments/core/payment_injection.dart';
import '../../features/results/core/result_injection.dart';
import '../../features/schedules/core/schedule_injection.dart';
import '../../features/teachers/core/teachers_injection.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =========================================================
  // CORE
  // =========================================================

  /// API Client - Singleton
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // =========================================================
  // FEATURES
  // =========================================================

  /// Auth
  await authDI.initAuthDI();

  /// Notification
  await initNotificationDI();

  /// Dashboard
  await initDashboardDI();

  /// Attendance
  await initAttendanceDI();

  /// Payment
  await initPaymentDI();

  /// Exams
  await initExamDI();

  /// Result
  await initResultDI();

  ///teachers
  await initTeacherDI();

    ///schedule
  await initScheduleDI();

  // Optional: Log registered dependencies
  // debugPrint('✅ All dependencies registered successfully!');
  // debugPrint('Registered: ${sl.instanceNames}');
}
