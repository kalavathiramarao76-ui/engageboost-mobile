import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String _endpoint = 'https://sai.sharedllm.com';
  String _model = 'gpt-oss:120b';
  ThemeMode _themeMode = ThemeMode.dark;

  String get endpoint => _endpoint;
  String get model => _model;
  ThemeMode get themeMode => _themeMode;

  SettingsModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _endpoint = prefs.getString('endpoint') ?? _endpoint;
    _model = prefs.getString('model') ?? _model;
    final themeIndex = prefs.getInt('themeMode') ?? 2;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> setEndpoint(String value) async {
    _endpoint = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('endpoint', value);
    notifyListeners();
  }

  Future<void> setModel(String value) async {
    _model = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('model', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _endpoint = 'https://sai.sharedllm.com';
    _model = 'gpt-oss:120b';
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
}
