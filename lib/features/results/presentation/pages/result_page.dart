// lib/features/results/presentation/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../bloc/result/result_bloc.dart';
import '../widgets/result_loading_widget.dart';
import '../widgets/result_not_published_widget.dart';
import '../widgets/result_error_widget.dart';
import '../widgets/student_result_card.dart';
import '../widgets/exam_details_card.dart';
import '../widgets/top_rankings_card.dart';

class ResultPage extends StatefulWidget {
  final int examId;
  final String examTitle;

  const ResultPage({
    super.key,
    required this.examId,
    required this.examTitle,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final ResultBloc _resultBloc;

  @override
  void initState() {
    super.initState();
    _resultBloc = context.read<ResultBloc>();
    _resultBloc.add(GetResultEvent(examId: widget.examId));
  }

  @override
  void dispose() {
    if (mounted) {
      _resultBloc.add(ClearResultEvent());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocConsumer<ResultBloc, ResultState>(
        listener: _handleStateChanges,
        builder: _buildBody,
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.examTitle,
        style: const TextStyle(
          fontFamily: AppFonts.heading,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(
          onPressed: _refreshResult,
          icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
        ),
      ],
    );
  }

  // =========================================================
  // LISTENER
  // =========================================================

  void _handleStateChanges(BuildContext context, ResultState state) {
    if (state is ResultError && mounted) {
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
  }

  // =========================================================
  // BUILD BODY
  // =========================================================

  Widget _buildBody(BuildContext context, ResultState state) {
    if (state is ResultLoading) {
      return const ResultLoadingWidget();
    }

    if (state is ResultNotPublished) {
      return ResultNotPublishedWidget(
        message: state.message,
        onRetry: _refreshResult,
      );
    }

    if (state is ResultError) {
      return ResultErrorWidget(
        message: state.message,
        onRetry: _refreshResult,
      );
    }

    if (state is ResultLoaded) {
      return _buildLoadedState(state);
    }

    return const SizedBox.shrink();
  }

  // =========================================================
  // LOADED STATE
  // =========================================================

  Widget _buildLoadedState(ResultLoaded state) {
    final data = state.data;
    final exam = data.exam;
    final result = data.studentResult;
    final rankings = data.topRankings;

    return RefreshIndicator(
      onRefresh: _refreshResultAsync,
      color: AppColors.primaryBlue,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Result Card
            StudentResultCard(result: result),

            const SizedBox(height: 16),

            // Exam Details Card
            ExamDetailsCard(exam: exam),

            const SizedBox(height: 16),

            // Top Rankings
            if (rankings.isNotEmpty)
              TopRankingsCard(
                rankings: rankings,
                studentRank: result.rank ?? 0,
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  void _refreshResult() {
    _resultBloc.add(GetResultEvent(examId: widget.examId));
  }

  Future<void> _refreshResultAsync() async {
    _resultBloc.add(GetResultEvent(examId: widget.examId));
    // Wait for state to change
    await Future.delayed(const Duration(milliseconds: 500));
  }
}