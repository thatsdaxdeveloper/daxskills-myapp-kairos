import 'package:flutter/foundation.dart';
import 'package:proto_kairos/controllers/preferences/auth_pref.dart';

class OnboardingProvider with ChangeNotifier {
  bool _isOnboardingCompleted = false;

  bool get isOnboardingCompleted => _isOnboardingCompleted;

  Future<void> putOnboardingCompleted(bool value) async {
    _isOnboardingCompleted = value;
    await AuthPref.setOnboardingCompleted(_isOnboardingCompleted);
    notifyListeners();
  }

  Future<void> init() async {
    _isOnboardingCompleted = await AuthPref.getOnboardingCompleted();
    notifyListeners();
  }

  OnboardingProvider() {
    init();
  }
}
