import 'package:shared_preferences/shared_preferences.dart';

class IsSeen {
  static const String value = 'isSeen';

  Future<void> setSeen(bool isSeen) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(value, isSeen);
  }

  Future<bool> getSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(value) ?? false;
  }
}