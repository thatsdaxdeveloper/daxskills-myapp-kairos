import 'package:shared_preferences/shared_preferences.dart';

class AuthPref {
  static const String _authPrefKey = "auth_pref";

  // Sauvegarder que l'onboarding a été complété
  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authPrefKey, value);
  }

  static Future<bool> getOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authPrefKey) ?? false;
  }
}
