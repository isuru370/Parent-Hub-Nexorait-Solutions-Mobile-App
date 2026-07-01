// lib/features/schedules/presentation/pages/schedules_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/schedule_model.dart';
import '../bloc/schedule/schedule_bloc.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_class_card.dart';
import '../widgets/schedule_shimmer.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  String? _selectedClassFilter;
  String? _selectedStatusFilter;

  final List<String> _statusFilters = [
    'All',
    'ongoing',
    'scheduled',
    'completed',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(GetSchedulesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Schedules',
          style: TextStyle(
            fontFamily: AppFonts.heading,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ScheduleBloc>().add(RefreshSchedulesEvent());
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          ),
        ],
      ),
      body: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const ScheduleShimmer();
          }

          if (state is ScheduleError) {
            return _buildErrorState(state);
          }

          if (state is ScheduleLoaded) {
            return _buildLoadedState(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(ScheduleError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                color: AppColors.error.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load schedules',
              style: TextStyle(
                fontFamily: AppFonts.heading,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
                context.read<ScheduleBloc>().add(RefreshSchedulesEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(ScheduleLoaded state) {
    final groupedClasses = state.groupedByClass;

    return Column(
      children: [
        // Filters
        _buildFilters(state),

        // Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${state.totalSchedules} schedules found',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(),
              if (_selectedClassFilter != null || _selectedStatusFilter != null)
                GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 14,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Clear Filters',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Schedule List
        Expanded(
          child: groupedClasses.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<ScheduleBloc>().add(RefreshSchedulesEvent());
                  },
                  color: AppColors.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: groupedClasses.keys.length,
                    itemBuilder: (context, index) {
                      final className = groupedClasses.keys.elementAt(index);
                      final schedules = groupedClasses[className]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ScheduleClassCard(
                          className: className,
                          schedules: schedules,
                          onTap: () {
                            _showClassScheduleDetails(
                              context,
                              className,
                              schedules,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilters(ScheduleLoaded state) {
    final uniqueClasses = state.uniqueClasses;

    return Column(
      children: [
        // Status Filters
        SingleChildScrollView(
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
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
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
                    context.read<ScheduleBloc>().add(
                      FilterSchedulesByStatusEvent(
                        status: status == 'All' ? null : status,
                      ),
                    );
                  },
                  backgroundColor: AppColors.lightBackground,
                  selectedColor: AppColors.primaryBlue,
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
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Class Filters
        if (uniqueClasses.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text(
                    'All Classes',
                    style: TextStyle(fontSize: 12),
                  ),
                  selected: _selectedClassFilter == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedClassFilter = null;
                    });
                    context.read<ScheduleBloc>().add(
                      FilterSchedulesByClassEvent(className: null),
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
                ...uniqueClasses.map((className) {
                  final isSelected = _selectedClassFilter == className;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        className,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedClassFilter = isSelected ? null : className;
                        });
                        context.read<ScheduleBloc>().add(
                          FilterSchedulesByClassEvent(
                            className: isSelected ? null : className,
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
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_outlined,
                size: 48,
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No schedules found',
              style: TextStyle(
                fontFamily: AppFonts.heading,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedClassFilter != null || _selectedStatusFilter != null
                  ? 'Try adjusting your filters'
                  : 'No schedules available for this student',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showClassScheduleDetails(
    BuildContext context,
    String className,
    List<ScheduleModel> schedules,
  ) {
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

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              className,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${schedules.length} schedules',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
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
                          '${schedules.length}',
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
                const SizedBox(height: 16),
                const Divider(height: 1),

                // Schedule List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ScheduleCard(schedule: schedule),
                      );
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

  void _clearFilters() {
    setState(() {
      _selectedClassFilter = null;
      _selectedStatusFilter = null;
    });
    context.read<ScheduleBloc>().add(
      FilterSchedulesByClassEvent(className: null),
    );
    context.read<ScheduleBloc>().add(
      FilterSchedulesByStatusEvent(status: null),
    );
  }
}
