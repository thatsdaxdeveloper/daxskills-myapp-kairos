import 'package:flutter/foundation.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';

class CountdownProvider with ChangeNotifier {
  final List<CountdownEntity> _countdowns = [];

  List<CountdownEntity> get countdowns => _countdowns;

  void addCountdown(CountdownEntity countdown) {
    _countdowns.add(countdown);
    notifyListeners();
  }
}