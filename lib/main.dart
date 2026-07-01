// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_hub/firebase_options.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/services/fcm_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/timezone_service.dart';
import 'core/storage/storage_service.dart';
import 'features/attendance/presentation/bloc/attendance/attendance_bloc.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/exams/presentation/bloc/exam/exam_bloc.dart';
import 'features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'features/notification/presentation/bloc/notification/notification_bloc.dart';
import 'features/payments/presentation/bloc/payment/payment_bloc.dart';
import 'features/results/presentation/bloc/result/result_bloc.dart';
import 'features/schedules/presentation/bloc/schedule/schedule_bloc.dart';
import 'features/teachers/presentation/bloc/teacher/teacher_bloc.dart';

Future<void> main() async {
  // Ensure all async operations are completed
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // =========================================================
    // 1. FIREBASE INITIALIZATION
    // =========================================================
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');

    // =========================================================
    // 2. FIREBASE MESSAGING
    // =========================================================
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    debugPrint('✅ Firebase Messaging handler set');

    // =========================================================
    // 3. NOTIFICATION SERVICE
    // =========================================================
    await NotificationService.instance.initialize();
    debugPrint('✅ Notification service initialized');

    // =========================================================
    // 4. FCM SERVICE
    // =========================================================
    await FCMService.instance.initialize();
    debugPrint('✅ FCM service initialized');

    // =========================================================
    // 5. TIMEZONE SERVICE
    // =========================================================
    await TimezoneService.initialize();
    debugPrint('✅ Timezone service initialized');

    // =========================================================
    // 6. STORAGE SERVICE
    // =========================================================
    await StorageService.init();
    debugPrint('✅ Storage service initialized');

    // =========================================================
    // 7. DEPENDENCY INJECTION
    // =========================================================
    await init();
    debugPrint('✅ Dependency injection initialized');

    // =========================================================
    // 8. RUN APP
    // =========================================================
    runApp(
      MultiBlocProvider(providers: _getBlocProviders(), child: const App()),
    );
    debugPrint('✅ App started successfully');
  } catch (e, stackTrace) {
    // Log any initialization errors
    debugPrint('❌ Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');

    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Retry initialization
                      main();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Get all BLoC providers
List<BlocProvider> _getBlocProviders() {
  return [
    BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
    BlocProvider<NotificationBloc>(create: (context) => sl<NotificationBloc>()),
    BlocProvider<DashboardBloc>(create: (context) => sl<DashboardBloc>()),
    BlocProvider<AttendanceBloc>(create: (context) => sl<AttendanceBloc>()),
    BlocProvider<PaymentBloc>(create: (context) => sl<PaymentBloc>()),
    BlocProvider<ExamBloc>(create: (context) => sl<ExamBloc>()),
    BlocProvider<ResultBloc>(create: (context) => sl<ResultBloc>()),
    BlocProvider<TeacherBloc>(create: (context) => sl<TeacherBloc>()),
    BlocProvider<ScheduleBloc>(create: (context) => sl<ScheduleBloc>()),
  ];
}
