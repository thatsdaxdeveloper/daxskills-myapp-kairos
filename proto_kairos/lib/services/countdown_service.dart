import 'package:hive_flutter/hive_flutter.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';

class CountdownService {
  static const String _boxName = 'countdowns_box';
  Box<CountdownEntity>? _countdownsBox;

  Future<void> init() async {
    // Vérifier si déjà initialisé
    if (_countdownsBox != null && _countdownsBox!.isOpen) {
      return;
    }

    // Enregistrer l'adapter seulement s'il n'est pas déjà enregistré
    if (!Hive.isAdapterRegistered(CountdownEntityAdapter().typeId)) {
      Hive.registerAdapter(CountdownEntityAdapter());
    }

    _countdownsBox = await Hive.openBox<CountdownEntity>(_boxName);
  }

  Box<CountdownEntity> get box {
    if (_countdownsBox == null || !_countdownsBox!.isOpen) {
      throw Exception('CountdownService not initialized. Call init() first.');
    }
    return _countdownsBox!;
  }

  // CRUD Operations
  Future<void> addCountdown(CountdownEntity countdown) async {
    await box.put(countdown.id, countdown);
  }

  Future<void> updateCountdown(CountdownEntity countdown) async {
    await box.put(countdown.id, countdown);
  }

  Future<void> deleteCountdown(String id) async {
    await box.delete(id);
  }

  List<CountdownEntity> getAllCountdowns() {
    return box.values.toList();
  }

  CountdownEntity? getCountdownById(String id) {
    return box.get(id);
  }

  List<CountdownEntity> getActiveCountdowns() {
    return box.values.where((c) => c.isInBox).toList();
  }

  // Fermeture propre
  Future<void> close() async {
    await _countdownsBox?.close();
  }
}