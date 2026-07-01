import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import 'widgets/banner_card.dart';
import 'widgets/payment_section.dart';
import 'widgets/quick_action_grid.dart';
import 'widgets/student_card.dart';
import 'widgets/today_classes_section.dart';
import 'widgets/upcoming_exam_section.dart';
import 'widgets/week_classes_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<DashboardBloc>().add(LoadDashboardEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            ),
          );
        }

        if (state is DashboardError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().add(LoadDashboardEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is DashboardLoaded) {
          final dashboard = state.dashboard;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    const RefreshDashboardEvent(),
                  );
                },
                color: AppColors.primaryBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------------------------------------------------
                      // MODERN HEADER WITH GRADIENT AVATAR
                      //--------------------------------------------------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///==========================================================
                          /// LEFT SIDE
                          ///==========================================================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Good Morning",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "👋",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  dashboard.student.initialName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primaryBlue,
                                        AppColors.darkBlue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryBlue
                                            .withOpacity(.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Grade ${dashboard.student.grade}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          ///==========================================================
                          /// RIGHT SIDE
                          ///==========================================================
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //-----------------------------------
                              // Notification Button (With Count)
                              //-----------------------------------
                              InkWell(
                                onTap: () {
                                  // ✅ Navigate to Notification List Page
                                  context.push(RouteNames.notifications);
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Center(
                                        child: Icon(
                                          Icons.notifications_outlined,
                                          color: AppColors.textPrimary,
                                          size: 25,
                                        ),
                                      ),

                                      // ✅ Notification Badge
                                      if (dashboard.notification.unreadCount >
                                          0)
                                        Positioned(
                                          right: 2,
                                          top: 2,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: AppColors.error,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                dashboard
                                                            .notification
                                                            .unreadCount >
                                                        9
                                                    ? '9+'
                                                    : dashboard
                                                          .notification
                                                          .unreadCount
                                                          .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              //-----------------------------------
                              // Profile
                              //-----------------------------------
                              InkWell(
                                onTap: () {
                                  context.go(RouteNames.profile);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primaryBlue,
                                        AppColors.darkBlue,
                                        AppColors.primaryOrange,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryBlue
                                            .withOpacity(.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      dashboard.student.imgUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // STUDENT CARD - Glassmorphism Design
                      //--------------------------------------------------
                      StudentCard(student: dashboard.student),
                      const SizedBox(height: 24),

                      //--------------------------------------------------
                      // BANNER CARD - Gradient Design
                      //--------------------------------------------------
                      BannerCard(banner: dashboard.banner),
                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // TODAY'S CLASSES - Modern Section
                      //--------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Classes",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TodayClassesSection(classes: dashboard.todayClasses),
                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // UPCOMING EXAMS - Modern Section
                      //--------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upcoming Exams",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push('${RouteNames.dashboard}/exams');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      UpcomingExamSection(exams: dashboard.upcomingExams),
                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // THIS WEEK CLASSES - Modern Section
                      //--------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "This Week Classes",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to weekly schedule
                              context.push('${RouteNames.dashboard}/schedule');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      WeekClassesSection(classes: dashboard.thisWeekClasses),
                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // RECENT PAYMENTS - Modern Section
                      //--------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Payments",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to payments
                              context.go(RouteNames.payments);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PaymentSection(payments: dashboard.recentPayments),
                      const SizedBox(height: 28),

                      //--------------------------------------------------
                      // QUICK ACTIONS - Neumorphism Design
                      //--------------------------------------------------
                      Text(
                        "Quick Actions",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const QuickActionGrid(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: SizedBox());
      },
    );
  }
}
