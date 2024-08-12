import 'package:flutter/material.dart';

class _HighlightModeManager extends InheritedWidget {
  _HighlightModeManager({required super.child});

  // Add any necessary properties or methods here

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
