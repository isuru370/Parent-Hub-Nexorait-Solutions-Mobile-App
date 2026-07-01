import 'package:flutter/material.dart';

class AppNavigatorKeys {
  AppNavigatorKeys._();

  static final root = GlobalKey<NavigatorState>();
  static final home = GlobalKey<NavigatorState>();
  static final attendance = GlobalKey<NavigatorState>();
  static final payments = GlobalKey<NavigatorState>();
  static final profile = GlobalKey<NavigatorState>();

  // Teachers
  static final teachers = GlobalKey<NavigatorState>();

  // ============================================
  // 🚀 GLOBAL NAVIGATOR KEY FOR NOTIFICATIONS
  // ============================================
  static final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Get current context from global navigator
  static BuildContext? get currentContext =>
      globalNavigatorKey.currentContext;
}