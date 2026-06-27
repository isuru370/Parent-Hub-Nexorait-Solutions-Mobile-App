import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/timezone_service.dart';
import '../../../data/model/class_schedule_model.dart';

class WeekClassesSection extends StatelessWidget {
  final List<ClassScheduleModel> classes;

  const WeekClassesSection({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.lightBackground],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.1),
                    AppColors.darkBlue.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 48,
                color: AppColors.primaryBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No classes this week",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Enjoy your break! 🌴",
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // Group classes by day
    final Map<String, List<ClassScheduleModel>> groupedClasses = {};
    for (var classItem in classes) {
      final dayKey = TimezoneService.formatDayFull(classItem.classDate);
      if (!groupedClasses.containsKey(dayKey)) {
        groupedClasses[dayKey] = [];
      }
      groupedClasses[dayKey]!.add(classItem);
    }

    return Column(
      children: groupedClasses.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.darkBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Divider(color: AppColors.border, thickness: 1),
                  ),
                  Text(
                    '${entry.value.length} class${entry.value.length > 1 ? 'es' : ''}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Classes for this day
            ...entry.value.map((item) {
              final isOngoing = item.liveStatus.toLowerCase() == 'ongoing';
              final isCompleted = item.liveStatus.toLowerCase() == 'completed';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isOngoing
                        ? [AppColors.success.withOpacity(0.05), Colors.white]
                        : isCompleted
                        ? [
                            AppColors.textDisabled.withOpacity(0.03),
                            Colors.white,
                          ]
                        : [Colors.white, Colors.white.withOpacity(0.95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isOngoing
                        ? AppColors.success.withOpacity(0.3)
                        : isCompleted
                        ? AppColors.textDisabled.withOpacity(0.1)
                        : AppColors.border.withOpacity(0.3),
                    width: isOngoing ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isOngoing
                          ? AppColors.success.withOpacity(0.1)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Time Box
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOngoing
                              ? [
                                  AppColors.success,
                                  AppColors.success.withOpacity(0.8),
                                ]
                              : isCompleted
                              ? [
                                  AppColors.textDisabled,
                                  AppColors.textDisabled.withOpacity(0.8),
                                ]
                              : [AppColors.primaryBlue, AppColors.darkBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isOngoing
                                        ? AppColors.success
                                        : AppColors.primaryBlue)
                                    .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            TimezoneService.formatTimeShort(item.startTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.white.withOpacity(0.3),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                          ),
                          Text(
                            TimezoneService.formatTimeShort(item.endTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.studentClass.subject.subjectName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isCompleted
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.studentClass.className,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.studentClass.teacher?.fullName ?? "-",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    _WeekStatusChip(status: item.liveStatus),
                  ],
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}

// Helper extension for TimezoneService
extension TimezoneServiceExtension on TimezoneService {
  static String formatDayFull(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  static String formatTimeShort(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 5 + (2 * _controller.value),
          height: 5 + (2 * _controller.value),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(
                  0.5 + (0.3 * _controller.value),
                ),
                blurRadius: 4 + (2 * _controller.value),
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekStatusChip extends StatelessWidget {
  final String status;

  const _WeekStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late Color bgColor;
    late String label;
    late IconData icon;

    switch (status.toLowerCase()) {
      case 'scheduled':
        color = AppColors.info;
        bgColor = AppColors.info.withOpacity(0.12);
        label = 'Scheduled';
        icon = Icons.schedule_rounded;
        break;

      case 'ongoing':
        color = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.12);
        label = 'In Progress';
        icon = Icons.play_circle_rounded;
        break;

      case 'completed':
        color = AppColors.textDisabled;
        bgColor = AppColors.textDisabled.withOpacity(0.12);
        label = 'Completed';
        icon = Icons.check_circle_rounded;
        break;

      case 'cancelled':
        color = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.12);
        label = 'Cancelled';
        icon = Icons.cancel_rounded;
        break;

      default:
        color = AppColors.warning;
        bgColor = AppColors.warning.withOpacity(0.12);
        label = status;
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
