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
import 'features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'features/notification/presentation/bloc/notification/notification_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.instance.initialize();

  await FCMService.instance.initialize();

  await TimezoneService.initialize();
  await StorageService.init();

  await init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
        BlocProvider(create: (_) => sl<DashboardBloc>()),
        BlocProvider(create: (_) => sl<AttendanceBloc>()),
      ],
      child: const App(),
    ),
  );
}
