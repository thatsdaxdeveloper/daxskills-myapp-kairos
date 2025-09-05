import 'package:hive_flutter/hive_flutter.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';

class CountdownService {
  static const String _boxName = 'countdowns_box';
  late Box<CountdownEntity> _countdownsBox;

  Future<void> init() async {
    Hive.registerAdapter(CountdownEntityAdapter());
    _countdownsBox = await Hive.openBox<CountdownEntity>(_boxName);
  }

  List<CountdownEntity> getAllCountdowns() {
    return _countdownsBox.values.toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
  }

  // Sauvegarder un compte à rebours
  Future<void> saveCountdown(CountdownEntity countdown) async {
    await _countdownsBox.put(countdown.id, countdown);
  }

  // Supprimer un compte à rebours
  Future<void> deleteCountdown(String id) async {
    await _countdownsBox.delete(id);
  }
}