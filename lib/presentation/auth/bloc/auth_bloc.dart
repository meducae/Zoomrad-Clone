import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(AuthInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(SendOtpLoading());
    try {
      await sendOtpUseCase(event.phone);
      emit(SendOtpSuccess(event.phone));
    } catch (e) {
      emit(SendOtpFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(VerifyOtpLoading());
    try {
      final result = await verifyOtpUseCase(event.phone, event.otp);
      emit(VerifyOtpSuccess(result));
    } catch (e) {
      emit(VerifyOtpFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
