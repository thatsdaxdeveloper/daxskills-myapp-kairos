import 'package:flutter/material.dart';

class MyToastificationFunc {
  static OverlayEntry? _currentOverlay;

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}