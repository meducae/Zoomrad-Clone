import 'package:equatable/equatable.dart';

class AuthResult extends Equatable {
  final String accessToken;
  final String refreshToken;
  final bool isNewUser;

  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, isNewUser];
}
