import 'package:easy_localization/easy_localization.dart';

class UpdateProfileFunctions {
  static String? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'enter_name'.tr();
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
  static String getAvatarPath(String avatarId) {
    return avatarId.contains("assets") ? avatarId : "assets/avatars/$avatarId.png";
  }
}