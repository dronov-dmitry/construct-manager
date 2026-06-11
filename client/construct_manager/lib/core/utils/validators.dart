class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'toast_fill_email';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'toast_invalid_email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'toast_fill_password';
    }
    if (value.length < 8) {
      return 'toast_password_length';
    }
    return null;
  }

  static String? repeatPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'toast_fill_password_again';
    }
    if (value != password) {
      return 'toast_passwords_dont_match';
    }
    return null;
  }

  static String? required(String? value, String errorKey) {
    if (value == null || value.trim().isEmpty) {
      return errorKey;
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'toast_fill_value';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'toast_value_only_numbers';
    }
    return null;
  }
}
