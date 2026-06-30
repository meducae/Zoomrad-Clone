import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phone);
  Future<AuthResponseModel> verifyOtp(String phone, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await dioClient.dio.post(
        '/api/v1/auth/send-otp',
        data: {'phone': phone},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp(String phone, String otp) async {
    try {
      final response = await dioClient.dio.post(
        '/api/v1/auth/verify-otp',
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      try {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['error'] != null) {
          final errorData = data['error'] as Map<String, dynamic>;
          final message = errorData['message'] as String?;
          if (message != null) {
            return Exception(message);
          }
        }
      } catch (_) {
        // Fallback if parsing fails
      }
    }
    return Exception(e.message ?? 'Tarmoqda xatolik yuz berdi');
  }
}
