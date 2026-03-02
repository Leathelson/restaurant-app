import 'package:flutter/material.dart';
import 'theme.dart';

/// A simple ChangeNotifier that tracks the current theme mode and
/// exposes the corresponding [ThemeData].
///
/// The widget tree can listen to this provider and rebuild when the
/// theme is toggled.  We keep an internal [_mode] and [_themeData]
/// so callers can either query the raw mode or the resolved data.
class ThemeProvider extends ChangeNotifier {
  // start with light by default
  ThemeMode _mode = ThemeMode.light;
  ThemeData _themeData = lightmode;

  ThemeMode get mode => _mode;
  ThemeData get themeData => _themeData;

  /// Switches to the given mode, updating the cached [ThemeData]
  /// and notifying listeners if the mode actually changed.
  set mode(ThemeMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    _themeData = newMode == ThemeMode.dark ? darkmode : lightmode;
    notifyListeners();
  }

  /// Convenience toggle method that flips between light and dark.
  void toggle() {
    mode = (_mode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
  }
}
