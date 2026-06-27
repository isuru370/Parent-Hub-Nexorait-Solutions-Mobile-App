import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/storage_keys.dart';
import '../storage/storage_service.dart';

class ApiClient {
  ApiClient();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final url = _buildUrl(endpoint);

      debugPrint('==================== API REQUEST ====================');
      debugPrint('METHOD : POST');
      debugPrint('URL    : $url');
      debugPrint('BODY   : $data');

      final response = await _dio.post(url, data: data);

      debugPrint('==================== API RESPONSE ====================');
      debugPrint('STATUS : ${response.statusCode}');
      debugPrint('DATA   : ${response.data}');

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = _buildUrl(endpoint);

      debugPrint('==================== API REQUEST ====================');
      debugPrint('METHOD : GET');
      debugPrint('URL    : $url');

      final response = await _dio.get(url);

      debugPrint('==================== API RESPONSE ====================');
      debugPrint('STATUS : ${response.statusCode}');
      debugPrint('DATA   : ${response.data}');

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  String _buildUrl(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }

    final baseUrl = StorageService.getString(StorageKeys.apiUrl);

    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('Institute API URL not found');
    }

    final uri = Uri.parse(baseUrl);
    return uri.resolve(endpoint).toString();
  }

  Never _handleError(DioException e) {
    debugPrint('==================== API ERROR ====================');
    debugPrint('STATUS  : ${e.response?.statusCode}');
    debugPrint('MESSAGE : ${e.message}');
    debugPrint('DATA    : ${e.response?.data}');

    if (e.response?.data is Map<String, dynamic>) {
      throw Exception(e.response?.data['message'] ?? 'Request failed');
    }

    throw Exception(e.message ?? 'Unable to connect to server');
  }
}
