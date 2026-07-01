// lib/features/teachers/presentation/pages/teachers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/teacher_model.dart';
import '../bloc/teacher/teacher_bloc.dart';
import '../widgets/teacher_card.dart';
import '../widgets/teacher_filter_chip.dart';
import '../widgets/teacher_shimmer.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGradeFilter;
  String? _selectedClassFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<TeacherBloc>().add(GetTeachersEvent());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TeacherBloc>().add(
      SearchTeachersEvent(query: _searchController.text),
    );
  }

  List<String> _getUniqueGrades(List<TeacherModel> teachers) {
    final grades = <String>{};
    for (final teacher in teachers) {
      for (final classItem in teacher.classes) {
        grades.add('Grade ${classItem.gradeName}');
      }
    }
    return grades.toList()..sort();
  }

  List<String> _getUniqueClasses(List<TeacherModel> teachers) {
    final classes = <String>{};
    for (final teacher in teachers) {
      for (final classItem in teacher.classes) {
        classes.add(classItem.className);
      }
    }
    return classes.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Teachers',
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
              context.read<TeacherBloc>().add(RefreshTeachersEvent());
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search teachers...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.lightBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TeacherBloc>().add(
                            SearchTeachersEvent(query: ''),
                          );
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherError) {
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
          if (state is TeacherLoading) {
            return const TeacherShimmer();
          }

          if (state is TeacherError) {
            return _buildErrorState(state);
          }

          if (state is TeacherLoaded) {
            return _buildLoadedState(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(TeacherError state) {
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
              'Failed to load teachers',
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
                context.read<TeacherBloc>().add(RefreshTeachersEvent());
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

  Widget _buildLoadedState(TeacherLoaded state) {
    final teachers = state.displayTeachers;
    final allTeachers = state.teachers;

    return Column(
      children: [
        // Filters
        if (allTeachers.isNotEmpty) _buildFilters(allTeachers),

        // Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${teachers.length} teacher${teachers.length != 1 ? 's' : ''} found',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(),
              // Count enrolled
              if (teachers.any((t) => t.hasMyClasses)) ...[
                Text(
                  '${teachers.where((t) => t.hasMyClasses).length} My Teacher${teachers.where((t) => t.hasMyClasses).length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (_selectedClassFilter != null || _selectedGradeFilter != null)
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

        // Teacher List
        Expanded(
          child: teachers.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<TeacherBloc>().add(RefreshTeachersEvent());
                  },
                  color: AppColors.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TeacherCard(teacher: teacher),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilters(List<TeacherModel> teachers) {
    final grades = _getUniqueGrades(teachers);
    final classes = _getUniqueClasses(teachers);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grade Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TeacherFilterChip(
                  label: 'All Grades',
                  isSelected: _selectedGradeFilter == null,
                  onSelected: () {
                    setState(() {
                      _selectedGradeFilter = null;
                    });
                    context.read<TeacherBloc>().add(
                      FilterTeachersByGradeEvent(gradeId: null),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ...grades.map((grade) {
                  final isSelected = _selectedGradeFilter == grade;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TeacherFilterChip(
                      label: grade,
                      isSelected: isSelected,
                      onSelected: () {
                        setState(() {
                          _selectedGradeFilter = isSelected ? null : grade;
                        });
                        final gradeId = int.tryParse(
                          grade.replaceAll('Grade ', ''),
                        );
                        context.read<TeacherBloc>().add(
                          FilterTeachersByGradeEvent(
                            gradeId: isSelected ? null : gradeId,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Class Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TeacherFilterChip(
                  label: 'All Classes',
                  isSelected: _selectedClassFilter == null,
                  onSelected: () {
                    setState(() {
                      _selectedClassFilter = null;
                    });
                    context.read<TeacherBloc>().add(
                      FilterTeachersByClassEvent(className: null),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ...classes.map((className) {
                  final isSelected = _selectedClassFilter == className;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TeacherFilterChip(
                      label: className,
                      isSelected: isSelected,
                      onSelected: () {
                        setState(() {
                          _selectedClassFilter = isSelected ? null : className;
                        });
                        context.read<TeacherBloc>().add(
                          FilterTeachersByClassEvent(
                            className: isSelected ? null : className,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
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
                Icons.person_off,
                size: 48,
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No teachers found',
              style: TextStyle(
                fontFamily: AppFonts.heading,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'No teachers available for this student',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<TeacherBloc>().add(
                    SearchTeachersEvent(query: ''),
                  );
                },
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedClassFilter = null;
      _selectedGradeFilter = null;
    });
    context.read<TeacherBloc>().add(
      FilterTeachersByClassEvent(className: null),
    );
    context.read<TeacherBloc>().add(FilterTeachersByGradeEvent(gradeId: null));
  }
}
