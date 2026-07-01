import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification/notification_bloc.dart';

class NotificationFilter extends StatelessWidget {
  final Widget child;

  const NotificationFilter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class NotificationFilterDialog extends StatefulWidget {
  const NotificationFilterDialog({super.key});

  @override
  State<NotificationFilterDialog> createState() =>
      _NotificationFilterDialogState();
}

class _NotificationFilterDialogState extends State<NotificationFilterDialog> {
  String? _selectedStatus;
  String? _selectedType;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  final List<String> _statuses = [
    'all',
    'pending',
    'sent',
    'failed',
    'cancelled',
  ];

  final List<String> _types = [
    'all',
    'general',
    'payment',
    'attendance',
    'exam',
    'result',
    'announcement',
    'reminder',
    'grade',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Status Filter
            _buildFilterDropdown(
              label: 'Status',
              value: _selectedStatus,
              items: _statuses,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value == 'all' ? null : value;
                });
              },
            ),

            const SizedBox(height: 12),

            // Type Filter
            _buildFilterDropdown(
              label: 'Type',
              value: _selectedType,
              items: _types,
              onChanged: (value) {
                setState(() {
                  _selectedType = value == 'all' ? null : value;
                });
              },
            ),

            const SizedBox(height: 12),

            // Date From
            _buildDatePicker(
              label: 'Date From',
              date: _dateFrom,
              onChanged: (date) {
                setState(() {
                  _dateFrom = date;
                });
              },
            ),

            const SizedBox(height: 12),

            // Date To
            _buildDatePicker(
              label: 'Date To',
              date: _dateTo,
              onChanged: (date) {
                setState(() {
                  _dateTo = date;
                });
              },
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text('All'),
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.toUpperCase()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.blue,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Select Date',
                    style: TextStyle(
                      color: date != null ? Colors.black : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedType = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }

  void _applyFilters() {
    Navigator.pop(context);

    final bloc = context.read<NotificationBloc>();

    bloc.add(
      LoadNotificationsEvent(
        status: _selectedStatus,
        type: _selectedType,
        dateFrom: _dateFrom?.toIso8601String().split('T').first,
        dateTo: _dateTo?.toIso8601String().split('T').first,
      ),
    );
  }
}