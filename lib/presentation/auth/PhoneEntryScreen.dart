import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../utils/themes/app_colors.dart';
import '../../utils/themes/app_text_stile.dart';
import '../../utils/themes/app_texts.dart';
import '../../utils/themes/theme_menager.dart';
import 'VerificationScreen.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';


class PhoneEntryScreen extends StatefulWidget {
  final ThemeManager themeManager;
  const PhoneEntryScreen({super.key, required this.themeManager});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  final maskFormatter = MaskTextInputFormatter(
    mask: '+998 (##) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _phoneController.text = "+998 ";
    _phoneController.addListener(() {
      setState(() {
        _isButtonEnabled = _phoneController.text.length == 19;
      });
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
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.themeManager.toggleTheme(!isDark),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ActionChip(
              avatar: Icon(Icons.language, size: 16, color: isDark ? Colors.white : Colors.black),
              label: Text(widget.themeManager.locale.languageCode.toUpperCase()),
              onPressed: () => _showLanguageBottomSheet(context),
            ),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SendOtpLoading) {
            _showLoadingDialog(context);
          } else if (state is SendOtpSuccess) {
            Navigator.pop(context); // pop loading
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  themeManager: widget.themeManager,
                  phoneNumber: state.phone,
                ),
              ),
            );
          } else if (state is SendOtpFailure) {
            Navigator.pop(context); // pop loading
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
                child: const Icon(Icons.login, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 32),


              Text(
                _lang('title'),
                style: AppTextStyles.heading.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),


              Text(
                _lang('subtitle'),
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _phoneController,
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  onPressed: _isButtonEnabled ? () => _showVerificationDialog(context) : null,
                  child: Text(
                    _lang('send_code'),
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_lang('select_lang'), style: AppTextStyles.heading.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              _buildLangTile('O\'zbekcha', 'uz'),
              _buildLangTile('Русский', 'ru'),
              _buildLangTile('English', 'en'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangTile(String title, String code) {
    bool isSelected = widget.themeManager.locale.languageCode == code;
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF109C5B)) : null,
      onTap: () {
        widget.themeManager.changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }


  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _phoneController.text,
                style: AppTextStyles.heading.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _lang('dialog_title'),
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),


              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? Colors.grey : Colors.black26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    _lang('no'),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF109C5B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[\s()-]'), '');
                    context.read<AuthBloc>().add(SendOtpRequested(cleanPhone));
                  },
                  child: Text(_lang('yes'), style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
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