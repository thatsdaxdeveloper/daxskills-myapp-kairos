import 'package:flutter/foundation.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';
import 'package:proto_kairos/services/countdown_service.dart';

class CountdownProvider with ChangeNotifier {
  final List<CountdownEntity> _countdowns = [];
  List<CountdownEntity> get countdowns => _countdowns;
  final CountdownService _service = CountdownService();
  bool _isInitialized = false;

  Future<void> addCountdown(CountdownEntity countdown) async {
    await _ensureInitialized();

    // Persister dans Hive
    await _service.addCountdown(countdown);

    // Mettre à jour la liste locale
    _countdowns.add(countdown);
    notifyListeners();
  }

  Future<void> updateCountdown(CountdownEntity updatedCountdown) async {
    await _ensureInitialized();

    final index = _countdowns.indexWhere((c) => c.id == updatedCountdown.id);
    if (index != -1) {
      // Persister dans Hive
      await _service.updateCountdown(updatedCountdown);

      // Mettre à jour la liste locale
      _countdowns[index] = updatedCountdown;
      notifyListeners();
    }
  }

  Future<void> removeCountdown(String eventId) async {
    await _ensureInitialized();

    // Supprimer de Hive
    await _service.deleteCountdown(eventId);

    // Mettre à jour la liste locale
    _countdowns.removeWhere((c) => c.id == eventId);
    notifyListeners();
  }

  Future<void> init() async {
    if (_isInitialized) return;

    // Initialiser le service
    await _service.init();

    // Charger les données existantes depuis Hive
    _countdowns.clear();
    _countdowns.addAll(_service.getAllCountdowns());

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  // Méthodes utilitaires
  List<CountdownEntity> getActiveCountdowns() {
    return _countdowns.where((c) => c.isInBox).toList();
  }

  CountdownEntity? getCountdownById(String id) {
    try {
      return _countdowns.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  CountdownProvider() {
    init();
  }
}