import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';

class TimezoneService {
  TimezoneService._();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation(AppConstants.appTimeZone));
  }

  static tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  static tz.TZDateTime fromDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Format Time (08:00 AM)
  static String formatTime(String time) {
    final now = TimezoneService.now();

    final dateTime = DateTime.parse(
      "${now.year.toString().padLeft(4, '0')}-"
      "${now.month.toString().padLeft(2, '0')}-"
      "${now.day.toString().padLeft(2, '0')} "
      "$time",
    );

    return DateFormat('hh:mm a').format(TimezoneService.fromDateTime(dateTime));
  }

  /// Format Time Short (08:00)
  static String formatTimeShort(String time) {
    final now = TimezoneService.now();

    final dateTime = DateTime.parse(
      "${now.year.toString().padLeft(4, '0')}-"
      "${now.month.toString().padLeft(2, '0')}-"
      "${now.day.toString().padLeft(2, '0')} "
      "$time",
    );

    return DateFormat('HH:mm').format(TimezoneService.fromDateTime(dateTime));
  }

  /// Format Time from DateTime (08:00 AM)
  static String formatTimeFromDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(fromDateTime(dateTime));
  }

  /// Format Time Short from DateTime (08:00)
  static String formatTimeShortFromDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(fromDateTime(dateTime));
  }

  /// Format Date (29 Jun 2026)
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(fromDateTime(date));
  }

  /// Format Day (29)
  static String formatDay(DateTime date) {
    return DateFormat('dd').format(fromDateTime(date));
  }

  /// Format Month (JUN)
  static String formatMonth(DateTime date) {
    return DateFormat('MMM').format(fromDateTime(date)).toUpperCase();
  }

  /// Format Date & Time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy hh:mm a').format(fromDateTime(date));
  }

  /// Format Month Year (Jun 2026)
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(fromDateTime(date));
  }

  /// Format Day Full (Monday)
  static String formatDayFull(DateTime date) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  }

  /// Format Day Short (Mon)
  static String formatDayShort(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  /// Format Duration (2h 30m)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Get time difference in hours (e.g., "2 hours ago", "3 hours left")
  static String getTimeDifference(DateTime dateTime) {
    final now = TimezoneService.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} left';
    } else {
      return 'Starting soon';
    }
  }

  /// Check if time is within range
  static bool isWithinTimeRange(String startTime, String endTime) {
    final now = TimezoneService.now();
    final start = DateTime.parse(
      "${now.year.toString().padLeft(4, '0')}-"
      "${now.month.toString().padLeft(2, '0')}-"
      "${now.day.toString().padLeft(2, '0')} "
      "$startTime",
    );
    final end = DateTime.parse(
      "${now.year.toString().padLeft(4, '0')}-"
      "${now.month.toString().padLeft(2, '0')}-"
      "${now.day.toString().padLeft(2, '0')} "
      "$endTime",
    );
    
    final startTZ = fromDateTime(start);
    final endTZ = fromDateTime(end);
    
    return now.isAfter(startTZ) && now.isBefore(endTZ);
  }

  /// Format relative time (e.g., "Today", "Tomorrow", "Yesterday")
  static String formatRelativeDate(DateTime date) {
    final now = TimezoneService.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final difference = dateOnly.difference(today).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0 && difference < 7) {
      return 'This ${formatDayFull(date)}';
    } else {
      return formatDate(date);
    }
  }

  /// Parse time string to DateTime (for calculations)
  static DateTime parseTimeString(String time) {
    final parts = time.split(':');
    if (parts.length == 2) {
      return DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    }
    return DateTime(2000, 1, 1, 0, 0);
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = TimezoneService.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}