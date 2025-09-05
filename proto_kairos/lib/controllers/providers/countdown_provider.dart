import 'package:flutter/foundation.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';
import 'package:proto_kairos/services/countdown_service.dart';

class CountdownProvider with ChangeNotifier {
  final CountdownService _service = CountdownService();
  final List<CountdownEntity> _countdowns = [];

  List<CountdownEntity> get countdowns => _countdowns;

  void addCountdown(CountdownEntity countdown) {
    _countdowns.add(countdown);
    notifyListeners();
  }

  void updateCountdown(CountdownEntity updatedCountdown) {
    final index = _countdowns.indexWhere((c) => c.id == updatedCountdown.id);
    if (index != -1) {
      _countdowns[index] = updatedCountdown;
      notifyListeners();
    }
  }

  void removeCountdown(String eventId) {
    _countdowns.removeWhere((c) => c.id == eventId);
    notifyListeners();
  }
}
