// lib/features/exams/presentation/pages/exams_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/model/exam_class_model.dart';
import '../../data/model/exam_model.dart';
import '../bloc/exam/exam_bloc.dart';
import '../widgets/exam_class_card.dart';
import '../widgets/exam_status_chip.dart';
import '../widgets/exam_summary_card.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  String? _selectedClassFilter;
  String? _selectedStatusFilter;

  final List<String> _statusFilters = [
    'All',
    'scheduled',
    'ongoing',
    'completed',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamBloc>().add(GetExamListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Exams'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ExamBloc>().add(RefreshExamListEvent());
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          ),
        ],
      ),
      body: BlocConsumer<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state is ExamError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExamLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (state is ExamError) {
            return _buildErrorState(state);
          }

          if (state is ExamLoaded) {
            return _buildLoadedState(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(ExamError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'Failed to load exams',
              style: TextStyle(
                fontFamily: AppFonts.heading,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ExamBloc>().add(RefreshExamListEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(ExamLoaded state) {
    final summary = state.summary;
    final classes = state.classes;
    final allClasses = state.allClasses;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ExamBloc>().add(RefreshExamListEvent());
      },
      color: AppColors.primaryBlue,
      child: CustomScrollView(
        slivers: [
          // Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ExamSummaryCard(
                totalClasses: summary.totalClasses,
                totalExams: summary.totalExams,
              ),
            ),
          ),

          // Status Filters
          SliverToBoxAdapter(child: _buildStatusFilters(state)),

          // Class Filters
          SliverToBoxAdapter(child: _buildClassFilters(allClasses, state)),

          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Class Exams',
                    style: TextStyle(
                      fontFamily: AppFonts.heading,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${classes.length} classes',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Class Cards
          if (classes.isEmpty)
            const SliverToBoxAdapter(child: _EmptyState())
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final classItem = classes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ExamClassCard(
                    classItem: classItem,
                    onTap: () {
                      _showExamDetails(context, classItem);
                    },
                  ),
                );
              }, childCount: classes.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildStatusFilters(ExamLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _statusFilters.map((status) {
          final isSelected =
              _selectedStatusFilter == status ||
              (status == 'All' && _selectedStatusFilter == null);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                status == 'All' ? 'All' : status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  if (status == 'All') {
                    _selectedStatusFilter = null;
                  } else {
                    _selectedStatusFilter = status;
                  }
                });
                context.read<ExamBloc>().add(
                  FilterExamsByStatusEvent(
                    status: status == 'All' ? null : status,
                  ),
                );
              },
              backgroundColor: AppColors.lightBackground,
              selectedColor: AppColors.primaryBlue,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? AppColors.primaryBlue : AppColors.border,
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClassFilters(List<ExamClassModel> allClasses, ExamLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All Classes', style: TextStyle(fontSize: 12)),
            selected: _selectedClassFilter == null,
            onSelected: (_) {
              setState(() {
                _selectedClassFilter = null;
              });
              context.read<ExamBloc>().add(
                FilterExamsByClassEvent(classId: null),
              );
            },
            backgroundColor: AppColors.lightBackground,
            selectedColor: AppColors.primaryBlue.withOpacity(0.1),
            shape: StadiumBorder(
              side: BorderSide(
                color: _selectedClassFilter == null
                    ? AppColors.primaryBlue
                    : AppColors.border,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...allClasses.map((classItem) {
            final isSelected = _selectedClassFilter == classItem.className;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  classItem.className,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedClassFilter = isSelected
                        ? null
                        : classItem.className;
                  });
                  context.read<ExamBloc>().add(
                    FilterExamsByClassEvent(
                      classId: isSelected ? null : classItem.classId,
                    ),
                  );
                },
                backgroundColor: AppColors.lightBackground,
                selectedColor: AppColors.primaryBlue.withOpacity(0.1),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.border,
                    width: 1,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showExamDetails(BuildContext context, ExamClassModel classItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 16),

                // =========================================================
                // HEADER
                // =========================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classItem.className,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${classItem.subjectName} • ${classItem.teacher}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryOrange.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${classItem.exams.length} Exams',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // =========================================================
                // STATUS SUMMARY
                // =========================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildBottomSheetStatusSummary(classItem),
                ),

                const SizedBox(height: 12),

                const Divider(height: 1),

                // =========================================================
                // EXAM LIST
                // =========================================================
                Expanded(
                  child: classItem.exams.isEmpty
                      ? const Center(
                          child: Text(
                            'No exams found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: classItem.exams.length,
                          itemBuilder: (context, index) {
                            final exam = classItem.exams[index];
                            final isLast = index == classItem.exams.length - 1;
                            return _buildExamDetailTile(context, exam, isLast);
                          },
                        ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetStatusSummary(ExamClassModel classItem) {
    final completedCount = classItem.exams.where((e) => e.isCompleted).length;
    final scheduledCount = classItem.exams.where((e) => e.isScheduled).length;
    final ongoingCount = classItem.exams.where((e) => e.isOngoing).length;
    final cancelledCount = classItem.exams.where((e) => e.isCancelled).length;

    return Row(
      children: [
        if (completedCount > 0)
          _buildBottomSheetStatusChip(
            label: 'Completed',
            count: completedCount,
            color: AppColors.success,
          ),
        if (scheduledCount > 0)
          _buildBottomSheetStatusChip(
            label: 'Scheduled',
            count: scheduledCount,
            color: AppColors.primaryBlue,
          ),
        if (ongoingCount > 0)
          _buildBottomSheetStatusChip(
            label: 'Ongoing',
            count: ongoingCount,
            color: AppColors.warning,
          ),
        if (cancelledCount > 0)
          _buildBottomSheetStatusChip(
            label: 'Cancelled',
            count: cancelledCount,
            color: AppColors.error,
          ),
      ],
    );
  }

  Widget _buildBottomSheetStatusChip({
    required String label,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.15), width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Updated Exam Detail Tile with View Result Button
  Widget _buildExamDetailTile(
    BuildContext context,
    ExamModel exam,
    bool isLast,
  ) {
    // ✅ Check if result can be viewed
    final canViewResult = exam.isCompleted;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast
                ? Colors.transparent
                : AppColors.border.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: exam.statusColor.withOpacity(0.1),
            ),
            child: Icon(exam.statusIcon, color: exam.statusColor, size: 18),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exam.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ExamStatusChip(status: exam.status, showIcon: false),
                  ],
                ),

                const SizedBox(height: 4),

                // Date & Time
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exam.examDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${exam.startTime} - ${exam.endTime}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Category, Hall & View Result Button
                Row(
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.book,
                            size: 10,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            exam.category.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Hall
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 10,
                            color: AppColors.primaryOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            exam.hall.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ✅ View Result Button - Fixed Navigation
                    if (canViewResult) _buildViewResultButton(context, exam),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ View Result Button Widget
  Widget _buildViewResultButton(BuildContext context, ExamModel exam) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.push(
          '${RouteNames.dashboard}/${RouteNames.exam}/${RouteNames.result}',
          extra: {'exam_id': exam.examId, 'exam_title': exam.title},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.darkBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'View Result',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// EMPTY STATE
// =========================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            'No Exams Found',
            style: TextStyle(
              fontFamily: AppFonts.heading,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No exams available for this student',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
