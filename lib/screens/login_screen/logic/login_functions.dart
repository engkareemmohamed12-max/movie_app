import 'package:easy_localization/easy_localization.dart';

class LoginFunctions {
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
}
