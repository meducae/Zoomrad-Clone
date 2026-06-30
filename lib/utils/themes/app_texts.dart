class AppTexts {
  static final Map<String, Map<String, String>> _localizedValues = {
    'uz': {
      'title': 'Telefon raqami',
      'subtitle': 'Ilovaga kirish uchun telefon raqamingizni kiriting',
      'send_code': 'Yuborish',
      'select_lang': 'Tilni tanlang',
      'dialog_title': 'Ushbu telefon raqami sizga yoki yaqin qarindoshingizga rasmiylashtirilganmi?',
      'yes': 'Ha, rasmiylashtirilgan',
      'no': 'Yo\'q, rasmiylashtirilmagan',
      'verify_title': 'Tasdiqlash',
      'verify_subtitle': 'Ushbu raqamga bir martalik kod yuborildi',
      'resend_code': 'Kodni qayta yuborish',
      'verify_button': 'Tasdiqlash',
    },
    'ru': {
      'title': 'Номер телефона',
      'subtitle': 'Введите свой номер телефона для входа в приложение',
      'send_code': 'Отправить код',
      'select_lang': 'Выбрать язык',
      'dialog_title': 'Данный номер телефона оформлен на вас или на ваших близких родственников?',
      'yes': 'Да, оформлен',
      'no': 'Нет, не оформлен',
      'verify_title': 'Подтверждение',
      'verify_subtitle': 'На этот номер был отправлен одноразовый проверочный код',
      'resend_code': 'Отправить код повторно',
      'verify_button': 'Подтверждение',
    },
    'en': {
      'title': 'Phone Number',
      'subtitle': 'Enter your phone number to enter the application',
      'send_code': 'Send Code',
      'select_lang': 'Select Language',
      'dialog_title': 'Is this phone number registered to you or your close relatives?',
      'yes': 'Yes, registered',
      'no': 'No, not registered',
      'verify_title': 'Verification',
      'verify_subtitle': 'A one-time verification code has been sent to this number',
      'resend_code': 'Resend Code',
      'verify_button': 'Verification',
    },
  };

  static String get(String key, String langCode) {
    return _localizedValues[langCode]?[key] ?? key;
  }
}