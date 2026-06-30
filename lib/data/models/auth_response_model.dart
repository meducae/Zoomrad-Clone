import '../../domain/entities/auth_result.dart';

class AuthResponseModel extends AuthResult {
  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.isNewUser,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      isNewUser: data['isNewUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'isNewUser': isNewUser,
    };
  }
}
