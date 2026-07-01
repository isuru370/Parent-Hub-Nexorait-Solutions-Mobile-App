import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification/notification_bloc.dart';

class NotificationDetailsPage extends StatefulWidget {
  final int notificationId;
  final String type;
  final String title;
  final String body;

  const NotificationDetailsPage({
    super.key,
    required this.notificationId,
    this.type = 'general',
    this.title = '',
    this.body = '',
  });

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  void initState() {
    super.initState();
    // If notificationId > 0, load details from API
    if (widget.notificationId > 0) {
      context.read<NotificationBloc>().add(
        LoadNotificationDetailsEvent(notificationId: widget.notificationId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        backgroundColor: _getColorForType(widget.type),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationOperationSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state is NotificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          // Show initial data from payload while loading
          if (state is NotificationInitial || state is NotificationLoading) {
            if (widget.title.isNotEmpty) {
              return _buildContentFromPayload(context);
            }
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationDetailsLoaded) {
            return _buildContent(context, state.notification);
          }

          if (state is NotificationFailure) {
            // Fallback to payload data if available
            if (widget.title.isNotEmpty) {
              return _buildContentFromPayload(context);
            }
            return _buildErrorState(state.message);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // ============================================
  // 🚀 BUILD CONTENT FROM API
  // ============================================
  Widget _buildContent(BuildContext context, dynamic notification) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getColorForType(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(notification.type),
                size: 48,
                color: _getColorForType(notification.type),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            notification.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Type Badge
          _buildTypeBadge(notification.type),
          const SizedBox(height: 8),

          // Status Badge
          _buildStatusBadge(notification.status),
          const SizedBox(height: 16),

          const Divider(),
          const SizedBox(height: 16),

          // Meta Information
          _buildInfoRow('ID', notification.id.toString()),
          _buildInfoRow('Type', notification.typeLabel),
          if (notification.student != null)
            _buildInfoRow('Student', notification.student!.name),
          if (notification.createdBy != null)
            _buildInfoRow('Created By', notification.createdBy!.name),
          _buildInfoRow('Status', notification.statusLabel),
          _buildInfoRow('Created', _formatDate(notification.createdAt)),
          if (notification.sentAt != null)
            _buildInfoRow('Sent', _formatDate(notification.sentAt!)),
          if (notification.readAt != null)
            _buildInfoRow('Read', _formatDate(notification.readAt!)),
          const SizedBox(height: 16),

          // Body/Message
          const Text(
            'Message',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              notification.body,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),

          // Extra Data (if any)
          if (notification.data != null && notification.data!.isNotEmpty)
            _buildExtraData(notification.data!),

          const SizedBox(height: 24),

          // Mark as Read Button
          if (!notification.isRead)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    MarkAsReadEvent(notificationId: notification.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Mark as Read'),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================
  // 🚀 BUILD CONTENT FROM PAYLOAD (Fallback)
  // ============================================
  Widget _buildContentFromPayload(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getColorForType(widget.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(widget.type),
                size: 48,
                color: _getColorForType(widget.type),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.title.isNotEmpty ? widget.title : 'Notification',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Type Badge
          _buildTypeBadge(widget.type),
          const SizedBox(height: 16),

          const Divider(),
          const SizedBox(height: 16),

          // Meta Information
          _buildInfoRow('ID', widget.notificationId.toString()),
          _buildInfoRow('Type', widget.type),
          _buildInfoRow('Date', DateTime.now().toString().substring(0, 16)),
          const SizedBox(height: 16),

          // Body/Message
          const Text(
            'Message',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              widget.body.isNotEmpty
                  ? widget.body
                  : 'No message content available.',
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // 🚀 HELPER WIDGETS
  // ============================================
  Widget _buildTypeBadge(String type) {
    final color = _getColorForType(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'sent':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      case 'cancelled':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildExtraData(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                LoadNotificationDetailsEvent(
                  notificationId: widget.notificationId,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text(
          'Are you sure you want to delete this notification?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationBloc>().add(
                DeleteNotificationEvent(notificationId: widget.notificationId),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'payment':
        return Colors.green;
      case 'attendance':
        return Colors.orange;
      case 'exam':
        return Colors.purple;
      case 'result':
        return Colors.indigo;
      case 'announcement':
        return Colors.cyan;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'attendance':
        return Icons.check_circle;
      case 'exam':
        return Icons.school;
      case 'result':
        return Icons.assessment;
      case 'announcement':
        return Icons.campaign;
      default:
        return Icons.notifications_active;
    }
  }
}
