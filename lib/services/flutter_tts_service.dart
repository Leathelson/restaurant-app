// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TTSService {
  static final TTSService instance = TTSService._internal();

  factory TTSService() => instance;

  TTSService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _enabled = false;

  bool get isEnabled => _enabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('tts_enabled') ?? false;
  }

  Future<void> toggle(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tts_enabled', value);
  }

  Future<void> setLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  Future<void> speak(String text) async {
    if (!_enabled) return;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}