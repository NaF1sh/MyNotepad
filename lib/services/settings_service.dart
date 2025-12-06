import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString('theme_mode') ?? 'dark';
    _backgroundImagePath = prefs.getString('background_image_path');
    notifyListeners();
  }

  Future<void> setTheme(String mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode);
    notifyListeners();
  }

  Future<void> setBackgroundImage(String? path) async {
    _backgroundImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      prefs.remove('background_image_path');
    } else {
      prefs.setString('background_image_path', path);
    }
    notifyListeners();
  }
}
