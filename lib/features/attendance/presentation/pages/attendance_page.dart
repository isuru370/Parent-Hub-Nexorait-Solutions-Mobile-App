// lib/features/attendance/presentation/pages/attendance_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/attendance_class_model.dart';
import '../bloc/attendance/attendance_bloc.dart';
import 'widgets/attendance_class_card.dart';
import 'widgets/attendance_history_bottom_sheet.dart';
import 'widgets/attendance_summary_card.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(GetAttendanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AttendanceBloc>().add(GetAttendanceEvent());
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (state is AttendanceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AttendanceBloc>().add(GetAttendanceEvent());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is AttendanceLoaded) {
            final data = state.response.data;
            final summary = data.summary;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AttendanceBloc>().add(GetAttendanceEvent());
              },
              color: AppColors.primaryBlue,
              child: CustomScrollView(
                slivers: [
                  // Summary Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: AttendanceSummaryCard(
                        totalSchedules: summary.totalSchedules,
                        totalClasses: summary.totalClasses,
                        presentClasses: summary.presentClasses,
                        absentClasses: summary.absentClasses,
                        attendancePercentage: summary.attendancePercentage,
                      ),
                    ),
                  ),

                  // Class List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Classes',
                        style: TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Class Cards
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final classItem = data.classes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: AttendanceClassCard(
                          classItem: classItem,
                          onTap: () {
                            _showHistoryBottomSheet(context, classItem);
                          },
                        ),
                      );
                    }, childCount: data.classes.length),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showHistoryBottomSheet(
    BuildContext context,
    AttendanceClassModel classItem,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AttendanceHistoryBottomSheet(classItem: classItem),
    );
  }
}
