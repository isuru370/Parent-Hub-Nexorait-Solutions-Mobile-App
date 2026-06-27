// lib/features/auth/data/model/student_model.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';

class StudentModel {
  // =========================================================
  // BASIC INFORMATION
  // =========================================================
  final int studentId;
  final String customId;
  final String temporaryId;
  final DateTime? temporaryIdExpire;

  // =========================================================
  // PERSONAL INFORMATION
  // =========================================================
  final String fullName;
  final String initialName;
  final String mobile;
  final String whatsappMobile;
  final String email;

  // =========================================================
  // DEMOGRAPHICS
  // =========================================================
  final String gender;
  final String? nic;
  final DateTime? bday;

  // =========================================================
  // ADDRESS
  // =========================================================
  final String? address1;
  final String? address2;
  final String? address3;

  // =========================================================
  // GUARDIAN INFORMATION
  // =========================================================
  final String? guardianFname;
  final String? guardianLname;
  final String? guardianNic;
  final String? guardianMobile;

  // =========================================================
  // ACADEMIC INFORMATION
  // =========================================================
  final int gradeId;
  final String? gradeName;
  final String? classType;
  final String? studentSchool;

  // =========================================================
  // IMAGE
  // =========================================================
  final String? imgUrl;
  final DateTime? lastImageUpdateAt;

  // =========================================================
  // STATUS FLAGS
  // =========================================================
  final bool isActive;
  final bool admission;
  final bool permanentQrActive;
  final bool studentDisable;

  // =========================================================
  // TIMESTAMPS
  // =========================================================
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentModel({
    // ========== Basic Information ==========
    required this.studentId,
    required this.customId,
    required this.temporaryId,
    this.temporaryIdExpire,

    // ========== Personal Information ==========
    required this.fullName,
    required this.initialName,
    required this.mobile,
    required this.whatsappMobile,
    required this.email,

    // ========== Demographics ==========
    required this.gender,
    this.nic,
    this.bday,

    // ========== Address ==========
    this.address1,
    this.address2,
    this.address3,

    // ========== Guardian Information ==========
    this.guardianFname,
    this.guardianLname,
    this.guardianNic,
    this.guardianMobile,

    // ========== Academic Information ==========
    required this.gradeId,
    this.gradeName,
    this.classType,
    this.studentSchool,

    // ========== Image ==========
    this.imgUrl,
    this.lastImageUpdateAt,

    // ========== Status Flags ==========
    required this.isActive,
    required this.admission,
    required this.permanentQrActive,
    required this.studentDisable,

    // ========== Timestamps ==========
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final apiUrl = StorageService.getString(StorageKeys.apiUrl) ?? '';
    final image = json['img_url']?.toString() ?? '';

    return StudentModel(
      studentId: _toInt(json['student_id']),
      customId: _toString(json['custom_id']),
      temporaryId: _toString(json['temporary_id']),
      temporaryIdExpire: _toDateTime(json['temporary_id_expire']),
      fullName: _toString(json['full_name']),
      initialName: _toString(json['initial_name']),
      mobile: _toString(json['mobile']),
      whatsappMobile: _toString(json['whatsapp_mobile']),
      email: _toString(json['email']),
      gender: _toString(json['gender']),
      nic: json['nic']?.toString(),
      bday: _toDateTime(json['bday']),
      address1: json['address1']?.toString(),
      address2: json['address2']?.toString(),
      address3: json['address3']?.toString(),
      guardianFname: json['guardian_fname']?.toString(),
      guardianLname: json['guardian_lname']?.toString(),
      guardianNic: json['guardian_nic']?.toString(),
      guardianMobile: json['guardian_mobile']?.toString(),
      gradeId: _toInt(json['grade_id']),
      gradeName: json['grade_name']?.toString(),
      classType: json['class_type']?.toString(),
      studentSchool: json['student_school']?.toString(),
      imgUrl: _buildImageUrl(image, apiUrl),
      lastImageUpdateAt: _toDateTime(json['last_image_update_at']),
      isActive: _toBool(json['is_active']),
      admission: _toBool(json['admission']),
      permanentQrActive: _toBool(json['permanent_qr_active']),
      studentDisable: _toBool(json['student_disable']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  static String _buildImageUrl(String image, String apiUrl) {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) return image;
    return '$apiUrl/storage/$image';
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    return value.toString().toLowerCase() == 'true';
  }

  static String _toString(dynamic value) {
    return value?.toString() ?? '';
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'custom_id': customId,
      'temporary_id': temporaryId,
      'temporary_id_expire': temporaryIdExpire?.toIso8601String(),
      'full_name': fullName,
      'initial_name': initialName,
      'mobile': mobile,
      'whatsapp_mobile': whatsappMobile,
      'email': email,
      'gender': gender,
      'nic': nic,
      'bday': bday?.toIso8601String(),
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'guardian_fname': guardianFname,
      'guardian_lname': guardianLname,
      'guardian_nic': guardianNic,
      'guardian_mobile': guardianMobile,
      'grade_id': gradeId,
      'grade_name': gradeName,
      'class_type': classType,
      'student_school': studentSchool,
      'img_url': imgUrl,
      'last_image_update_at': lastImageUpdateAt?.toIso8601String(),
      'is_active': isActive,
      'admission': admission,
      'permanent_qr_active': permanentQrActive,
      'student_disable': studentDisable,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // =========================================================
  // HELPER METHODS
  // =========================================================

  String get guardianFullName {
    if (guardianFname != null && guardianLname != null) {
      return '$guardianFname $guardianLname';
    }
    return guardianFname ?? guardianLname ?? '';
  }

  String get fullAddress {
    final parts = [
      address1,
      address2,
      address3,
    ].where((e) => e != null && e.isNotEmpty);
    return parts.join(', ');
  }

  bool get hasGuardian {
    return (guardianFname != null && guardianFname!.isNotEmpty) ||
        (guardianMobile != null && guardianMobile!.isNotEmpty);
  }

  bool get hasAddress {
    return (address1 != null && address1!.isNotEmpty) ||
        (address2 != null && address2!.isNotEmpty);
  }

  String get genderDisplay {
    if (gender.isEmpty) return 'Not specified';
    return gender[0].toUpperCase() + gender.substring(1);
  }

  bool get isActiveStudent => isActive && !studentDisable;

  String get statusDisplay {
    if (!isActive) return 'Inactive';
    if (studentDisable) return 'Disabled';
    return 'Active';
  }

  Color get statusColor {
    if (!isActive) return Colors.grey;
    if (studentDisable) return Colors.orange;
    return Colors.green;
  }

  String get admissionDisplay {
    return admission ? 'Admitted' : 'Not Admitted';
  }

  String get classTypeDisplay {
    return classType ?? 'Not specified';
  }

  String get profileImageUrl {
    return imgUrl ?? '';
  }

  bool get hasProfileImage {
    return imgUrl != null && imgUrl!.isNotEmpty;
  }

  // ✅ Temporary ID related helpers
  bool get hasTemporaryId {
    return temporaryId.isNotEmpty;
  }

  bool get isTemporaryIdExpired {
    if (temporaryIdExpire == null) return true;
    return DateTime.now().isAfter(temporaryIdExpire!);
  }

  String get temporaryIdStatus {
    if (!hasTemporaryId) return 'Not Available';
    if (isTemporaryIdExpired) return 'Expired';
    return 'Valid';
  }

  Color get temporaryIdStatusColor {
    if (!hasTemporaryId) return AppColors.textSecondary;
    if (isTemporaryIdExpired) return AppColors.error;
    return AppColors.success;
  }

  String get temporaryIdExpireDisplay {
    if (temporaryIdExpire == null) return 'No expiry date';
    final now = DateTime.now();
    final diff = temporaryIdExpire!.difference(now);

    if (diff.inDays > 0) {
      return 'Expires in ${diff.inDays} days';
    } else if (diff.inHours > 0) {
      return 'Expires in ${diff.inHours} hours';
    } else if (diff.inMinutes > 0) {
      return 'Expires in ${diff.inMinutes} minutes';
    } else {
      return 'Expired';
    }
  }

  String get temporaryIdExpireDateDisplay {
    if (temporaryIdExpire == null) return 'No expiry date';
    return _formatDate(temporaryIdExpire!);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
