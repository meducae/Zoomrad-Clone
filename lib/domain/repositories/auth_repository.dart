import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phone);
  Future<AuthResult> verifyOtp(String phone, String otp);
}
