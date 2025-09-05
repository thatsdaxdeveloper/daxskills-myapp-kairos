import 'package:hive_flutter/hive_flutter.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';

class CountdownService {
  static const String _boxName = 'countdowns';
  late Box<CountdownEntity> _countdownsBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CountdownEntityAdapter());
    }
    _countdownsBox = await Hive.openBox<CountdownEntity>(_boxName);
  }

  List<CountdownEntity> getAllCountdowns() {
    return _countdownsBox.values.toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
  }

  Future<void> addCountdown(CountdownEntity countdown) async {
    await _countdownsBox.put(countdown.id, countdown);
  }

  Future<void> updateCountdown(CountdownEntity countdown) async {
    await countdown.save();
  }

  Future<void> deleteCountdown(String id) async {
    await _countdownsBox.delete(id);
  }
}