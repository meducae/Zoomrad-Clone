import 'package:flutter/material.dart';
import '../../utils/themes/app_colors.dart';
import '../../utils/themes/app_text_stile.dart';
import '../../utils/themes/app_texts.dart';
import '../../utils/themes/theme_menager.dart';

class PasswordScreen extends StatefulWidget {
  final ThemeManager themeManager;
  const PasswordScreen({super.key, required this.themeManager});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isButtonEnabled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _isButtonEnabled = _passwordController.text.isNotEmpty;
        if (_errorMessage != null) _errorMessage = null;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _lang(String key) {
    return AppTexts.get(key, widget.themeManager.locale.languageCode);
  }

  void _validatePassword() {
    if (_passwordController.text == "123456") {
      setState(() {
        _errorMessage = null;
      });

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => const NextScreen()),
      //       (route) => false, // Orqaga qaytib bo'lmaydigan qiladi
      // );
    } else {
      setState(() {
        _errorMessage = _lang('password_error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: isDark ? Colors.white10 : Colors.black12,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                _lang('password_title'),
                style: AppTextStyles.heading.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                _lang('password_subtitle'),
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                _lang('password_label'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorMessage != null
                        ? Colors.red
                        : const Color(0xFF109C5B),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: _lang('password_hint'),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF109C5B),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  _lang('forgot_password'),
                  style: const TextStyle(
                    color: Color(0xFF109C5B),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
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
                  onPressed: _isButtonEnabled ? _validatePassword : null,
                  child: Text(
                    _lang('continue_button'),
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}