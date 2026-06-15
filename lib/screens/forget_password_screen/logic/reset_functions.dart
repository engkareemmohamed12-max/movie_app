import 'package:easy_localization/easy_localization.dart';

class ResetFunctions {
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
}