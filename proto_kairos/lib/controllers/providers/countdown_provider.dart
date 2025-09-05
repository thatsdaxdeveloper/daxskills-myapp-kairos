import 'package:flutter/foundation.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';
import 'package:proto_kairos/services/countdown_service.dart';

class CountdownProvider with ChangeNotifier {
  CountdownService _service = CountdownService();
  CountdownProvider(this._service);

  final List<CountdownEntity> _countdowns = [];

  List<CountdownEntity> get countdowns => _countdowns;

  Future<void> loadCountdowns() async {
    _countdowns.clear();
    _countdowns.addAll(_service.getAllCountdowns());
    notifyListeners();
  }

  void addCountdown(CountdownEntity countdown) {
    _countdowns.add(countdown);
    _service.saveCountdown(countdown);
    notifyListeners();
  }

  void updateCountdown(CountdownEntity updatedCountdown) {
    final index = _countdowns.indexWhere((c) => c.id == updatedCountdown.id);
    if (index != -1) {
      _countdowns[index] = updatedCountdown;
      _service.saveCountdown(updatedCountdown);
      notifyListeners();
    }
  }

  void removeCountdown(String eventId) {
    _countdowns.removeWhere((c) => c.id == eventId);
    _service.deleteCountdown(eventId);
    notifyListeners();
  }
}
