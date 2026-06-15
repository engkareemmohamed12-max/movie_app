import 'package:easy_localization/easy_localization.dart';

class RegisterFunctions {
  static String? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'enter_name'.tr();
    }
    return null;
  }

  static String? emailValidation({required String? email}) {
    if (email == null || email.trim().isEmpty) {
      return 'enter_email'.tr();
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    if (!emailValid) {
      return 'enter_valid_email'.tr();
    }
    return null;
  }

  static String? passwordValidation({required String? password}) {
    if (password == null || password.trim().isEmpty) {
      return 'enter_password'.tr();
    }
    final bool passwordValid = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    ).hasMatch(password);
    if (!passwordValid) {
      return 'enter_valid_password'.tr();
    }
    return null;
  }

  static String? confirmPasswordValidation({
    required String? password,
    required String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'enter_password'.tr();
    }
    if (confirmPassword != password) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }

  static String? phoneValidation({required String? phone}) {
    if (phone == null || phone.trim().isEmpty) {
      return 'enter_phone'.tr();
    }
    if (phone.length < 11) {
      return 'enter_valid_phone'.tr();
    }
    return null;
  }
}
