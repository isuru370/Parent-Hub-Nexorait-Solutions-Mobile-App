import 'banner_model.dart';
import 'student_model.dart';
import 'class_schedule_model.dart';
import 'exam_model.dart';
import 'payment_model.dart';

class DashboardDataModel {
  final BannerModel banner;
  final StudentModel student;
  final int totalClasses;
  final List<ClassScheduleModel> todayClasses;
  final List<ClassScheduleModel> thisWeekClasses;
  final List<ExamModel> upcomingExams;
  final List<PaymentModel> recentPayments;

  DashboardDataModel({
    required this.banner,
    required this.student,
    required this.totalClasses,
    required this.todayClasses,
    required this.thisWeekClasses,
    required this.upcomingExams,
    required this.recentPayments,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      banner: BannerModel.fromJson(json["banner"]),
      student: StudentModel.fromJson(json["student"]),
      totalClasses: json["total_classes"],
      todayClasses: (json["today_classes"] as List)
          .map((e) => ClassScheduleModel.fromJson(e))
          .toList(),
      thisWeekClasses: (json["this_week_classes"] as List)
          .map((e) => ClassScheduleModel.fromJson(e))
          .toList(),
      upcomingExams: (json["upcoming_exams"] as List)
          .map((e) => ExamModel.fromJson(e))
          .toList(),
      recentPayments: (json["recent_payments"] as List)
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
    );
  }
}