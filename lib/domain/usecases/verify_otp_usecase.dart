import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthResult> call(String phone, String otp) async {
    return await repository.verifyOtp(phone, otp);
  }
}
