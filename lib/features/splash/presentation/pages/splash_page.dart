import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = StorageService.getBool(StorageKeys.isLoggedIn);

    if (isLoggedIn) {
      context.go(RouteNames.dashboard);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [AppColors.primaryBlue, AppColors.darkBlue],
          ),
        ),

        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),

              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // Logo Card
                      Container(
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(28),

                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, 12),
                              color: Colors.black12,
                            ),
                          ],
                        ),

                        child: Image.asset('assets/logo/logo.png', height: 110),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'NexoraIT Connect',

                        textAlign: TextAlign.center,

                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'One App for Every Institute',

                        textAlign: TextAlign.center,

                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: 180,
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 24,

                left: 0,

                right: 0,

                child: Column(
                  children: [
                    Text(
                      'Powered by NexoraIT',

                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Version 1.0.0',

                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
