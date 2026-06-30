import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await remoteDataSource.sendOtp(phone);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(phone, otp);
      
      // Save tokens locally on success
      await sharedPreferences.setString('accessToken', result.accessToken);
      await sharedPreferences.setString('refreshToken', result.refreshToken);
      
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
