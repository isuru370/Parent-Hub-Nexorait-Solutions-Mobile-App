import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';

class StudentModel {
  final int id;
  final String customId;
  final String temporaryQrCode;
  final String initialName;
  final String grade;
  final String imgUrl;

  StudentModel({
    required this.id,
    required this.customId,
    required this.temporaryQrCode,
    required this.initialName,
    required this.grade,
    required this.imgUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final apiUrl = StorageService.getString(StorageKeys.apiUrl) ?? '';

    final image = json['img_url']?.toString() ?? '';

    return StudentModel(
      id: json['id'],
      customId: json['custom_id'],
      temporaryQrCode: json['temporary_qr_code'],
      initialName: json['initial_name'],
      grade: json['grade'],
      imgUrl: image.isEmpty ? '' : '$apiUrl/storage/$image',
    );
  }
}
