import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomradclone/presentation/auth/PasswordScreen.dart';

import '../../utils/themes/app_colors.dart';
import '../../utils/themes/app_text_stile.dart';
import '../../utils/themes/app_texts.dart';
import '../../utils/themes/theme_menager.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';


class VerificationScreen extends StatefulWidget {
  final ThemeManager themeManager;
  final String phoneNumber;

  const VerificationScreen({
    super.key,
    required this.themeManager,
    required this.phoneNumber,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final int _codeLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _isButtonEnabled = false;

  late Timer _timer;
  int _secondsRemaining = 120;
  bool _canResendCode = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _codeLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResendCode = false;
    _secondsRemaining = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResendCode = true;
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onCodeChanged() {
    bool allFilled = true;
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        allFilled = false;
        break;
      }
    }
    setState(() {
      _isButtonEnabled = allFilled;
    });
  }

  String _lang(String key) {
    return AppTexts.get(key, widget.themeManager.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpLoading) {
            _showLoadingDialog(context);
          } else if (state is VerifyOtpSuccess) {
            Navigator.pop(context); // pop loading dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordScreen(themeManager: widget.themeManager),
              ),
            );
          } else if (state is VerifyOtpFailure) {
            Navigator.pop(context); // pop loading dialog
            _showErrorDialog(context, state.error);
          } else if (state is SendOtpLoading) {
            _showLoadingDialog(context);
          } else if (state is SendOtpSuccess) {
            Navigator.pop(context); // pop loading dialog
            _startTimer(); // reset the timer
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kod muvaffaqiyatli yuborildi')),
            );
          } else if (state is SendOtpFailure) {
            Navigator.pop(context); // pop loading dialog
            _showErrorDialog(context, state.error);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF109C5B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 32),

              Text(
                _lang('verify_title'),
                style: AppTextStyles.heading.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                _lang('verify_subtitle'),
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.phoneNumber,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF109C5B), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_codeLength, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark ? Colors.grey : Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF109C5B), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < _codeLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        _onCodeChanged();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _canResendCode
                        ? () {
                            context.read<AuthBloc>().add(SendOtpRequested(widget.phoneNumber));
                          }
                        : null,
                    child: Text(
                      _lang('resend_code'),
                      style: AppTextStyles.body.copyWith(
                        color: _canResendCode
                            ? const Color(0xFF109C5B)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        fontWeight: _canResendCode ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _formatTime(_secondsRemaining),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? AppColors.lightPrimaryButton
                        : (isDark ? AppColors.darkDisabledButton : AppColors.lightDisabledButton),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                          final otpCode = _controllers.map((c) => c.text).join();
                          context.read<AuthBloc>().add(VerifyOtpRequested(
                                phone: widget.phoneNumber,
                                otp: otpCode,
                              ));
                        }
                      : null,
                  child: Text(
                    _lang('verify_button'),
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF109C5B),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xatolik'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF109C5B))),
          ),
        ],
      ),
    );
  }
}