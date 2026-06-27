import 'dashboard_data_model.dart';

class DashboardResponseModel {
  final bool status;
  final String message;
  final DashboardDataModel data;

  DashboardResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      status: json["status"],
      message: json["message"],
      data: DashboardDataModel.fromJson(json["data"]),
    );
  }
}