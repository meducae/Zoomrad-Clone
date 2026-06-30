import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_result.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class SendOtpLoading extends AuthState {}

class SendOtpSuccess extends AuthState {
  final String phone;

  const SendOtpSuccess(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SendOtpFailure extends AuthState {
  final String error;

  const SendOtpFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {
  final AuthResult result;

  const VerifyOtpSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class VerifyOtpFailure extends AuthState {
  final String error;

  const VerifyOtpFailure(this.error);

  @override
  List<Object?> get props => [error];
}
