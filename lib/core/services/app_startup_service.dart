import 'package:cineluxe/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../prefs/is_seen.dart';

class AppStartupService {
  static Future<void> handleStartup(BuildContext context) async {
    // Check onboarding
    final bool isSeen = await IsSeen().getSeen();

    if (!isSeen) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboardingScreen);

      return;
    }

    // Check login state
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }
}
