// lib/features/payments/presentation/pages/payments_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../data/model/payment_class_model.dart';
import '../bloc/payment/payment_bloc.dart';
import '../widgets/payment_class_card.dart';
import '../widgets/payment_filter_chip.dart';
import '../widgets/payment_history_bottom_sheet.dart';
import '../widgets/payment_summary_card.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPayments();
    });
  }

  void _loadPayments() {
    context.read<PaymentBloc>().add(GetPaymentHistoryEvent());
  }

  void _refreshPayments() {
    context.read<PaymentBloc>().add(RefreshPaymentHistoryEvent());
  }

  void _filterByClass(int? classId, String className) {
    setState(() {
      _selectedFilter = className;
    });
    context.read<PaymentBloc>().add(
      FilterPaymentsByClassEvent(classId: classId),
    );
  }

  void _clearFilter() {
    setState(() {
      _selectedFilter = null;
    });
    context.read<PaymentBloc>().add(FilterPaymentsByClassEvent(classId: null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is PaymentLoading) {
            return _buildLoadingState();
          }

          if (state is PaymentError) {
            return _buildErrorState(state);
          }

          if (state is PaymentLoaded) {
            return _buildLoadedState(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Payments',
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
          onPressed: _refreshPayments,
          icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  // =========================================================
  // STATE HANDLERS
  // =========================================================

  void _handleStateChanges(BuildContext context, PaymentState state) {
    if (state is PaymentError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  // =========================================================
  // LOADING STATE
  // =========================================================

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryBlue,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading payment data...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget _buildErrorState(PaymentError state) {
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
              'Oops! Something went wrong',
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
              onPressed: _refreshPayments,
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

  // =========================================================
  // LOADED STATE
  // =========================================================

  Widget _buildLoadedState(PaymentLoaded state) {
    final summary = state.summary;
    final classes = state.classes;
    final allClasses = state.allClasses;

    return RefreshIndicator(
      onRefresh: () async {
        _refreshPayments();
      },
      color: AppColors.primaryBlue,
      child: CustomScrollView(
        slivers: [
          // =============================================
          // SUMMARY CARD
          // =============================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PaymentSummaryCard(
                totalClasses: summary.totalClasses,
                totalPayments: summary.totalPayments,
                totalPaidAmount: summary.totalPaidAmount,
                totalUnpaidMonths: summary.totalUnpaidMonths,
                currentMonth: _getCurrentMonthDisplay(summary.currentMonth),
              ),
            ),
          ),

          // =============================================
          // FILTERS
          // =============================================
          SliverToBoxAdapter(child: _buildFilterBar(allClasses)),

          // =============================================
          // SECTION HEADER
          // =============================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Class Payments',
                    style: TextStyle(
                      fontFamily: AppFonts.heading,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedFilter != null)
                    GestureDetector(
                      onTap: _clearFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Clear Filter',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // =============================================
          // CLASS LIST
          // =============================================
          if (classes.isEmpty)
            const SliverToBoxAdapter(child: _EmptyState())
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final classItem = classes[index];
                final isFirst = index == 0;
                final isLast = index == classes.length - 1;

                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: isFirst ? 0 : 8,
                    bottom: isLast ? 8 : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: PaymentClassCard(
                      classItem: classItem,
                      onTap: () => _showPaymentDetails(context, classItem),
                    ),
                  ),
                );
              }, childCount: classes.length),
            ),

          // =============================================
          // BOTTOM SPACER
          // =============================================
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // =========================================================
  // FILTER BAR
  // =========================================================

  Widget _buildFilterBar(List<PaymentClassModel> allClasses) {
    final filters = [
      {'id': null, 'name': 'All'},
      ...allClasses.map((c) => {'id': c.classId, 'name': c.className}),
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected =
              _selectedFilter == filter['name'] ||
              (_selectedFilter == null && filter['name'] == 'All');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PaymentFilterChip(
              label: filter['name'] as String,
              isSelected: isSelected,
              onSelected: () {
                if (filter['name'] == 'All') {
                  _clearFilter();
                } else {
                  _filterByClass(
                    filter['id'] as int?,
                    filter['name'] as String,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // PAYMENT DETAILS BOTTOM SHEET
  // =========================================================

  void _showPaymentDetails(BuildContext context, PaymentClassModel classItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentHistoryBottomSheet(classItem: classItem),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  String _getCurrentMonthDisplay(String month) {
    if (month.isEmpty) return '';
    final parts = month.split('-');
    if (parts.length != 2) return month;

    final monthNames = {
      '01': 'January',
      '02': 'February',
      '03': 'March',
      '04': 'April',
      '05': 'May',
      '06': 'June',
      '07': 'July',
      '08': 'August',
      '09': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
    };

    return '${monthNames[parts[1]] ?? parts[1]} ${parts[0]}';
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payment_outlined,
              size: 48,
              color: AppColors.textDisabled,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Payment Records',
            style: TextStyle(
              fontFamily: AppFonts.heading,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No payment data available for this student',
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
