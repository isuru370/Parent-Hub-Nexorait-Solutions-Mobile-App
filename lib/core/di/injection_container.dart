import 'package:get_it/get_it.dart';

import '../../features/attendance/core/attendance_injection.dart';
import '../../features/auth/core/login_injection.dart' as authDI;
import '../../features/home/core/dashboard_injection.dart';
import '../../features/notification/core/notification_injection.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Features
  await authDI.initAuthDI();
  await initNotificationDI();
  await initDashboardDI();
  await initAttendanceDI();
}
