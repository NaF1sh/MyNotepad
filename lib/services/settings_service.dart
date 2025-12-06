import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class handles App Settings (Theme, Background)
class SettingsService with ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  String _themeMode = 'dark';
  String? _backgroundImagePath;

  String get themeMode => _themeMode;
  String? get backgroundImagePath => _backgroundImagePath;

  // Load saved settings when app starts
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString('theme_mode') ?? 'dark';
    _backgroundImagePath = prefs.getString('background_image_path');
    notifyListeners(); // Update UI
  }

  // Change Theme
  Future<void> setTheme(String mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode);
    notifyListeners(); // Update UI
  }

  // Change Background
  Future<void> setBackgroundImage(String? path) async {
    _backgroundImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      prefs.remove('background_image_path');
    } else {
      prefs.setString('background_image_path', path);
    }
    notifyListeners(); // Update UI
  }
}
