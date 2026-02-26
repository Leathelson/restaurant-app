// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isEnabled = false;

   // ✅ Singleton instance
  static TTSService? _instance;
  
  static TTSService get instance {
    _instance ??= TTSService();
    return _instance!;
  }

  bool get isEnabled => _isEnabled;

  Future<void> init() async {
  if (_isInitialized) return;

  await _flutterTts.setSharedInstance(true);

  if (Platform.isIOS) {
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ],
    );
  }

  _flutterTts.setErrorHandler((msg) {
    print("TTS Error: $msg");
  });

  await loadTTSPreference(); // ✅ restore saved setting

  _isInitialized = true;
}

  Future<bool> isLanguageAvailable(String languageCode) async {
    final languages = await _flutterTts.getLanguages;
    return languages.contains(languageCode);
  }

  Future<void> setLanguage(String languageCode) async {
    await init();
    // Map your app languages to BCP-47 codes
    final ttsLang = _mapToTTSLanguageCode(languageCode);
    if (await isLanguageAvailable(ttsLang)) {
      await _flutterTts.setLanguage(ttsLang);
    }
  }

  // Map your app's language names to system TTS codes
  String _mapToTTSLanguageCode(String appLanguage) {
    switch (appLanguage) {
      case 'English': return 'en-US';
      case 'Spanish': return 'es-ES';
      case 'French': return 'fr-FR';
      default: return 'en-US';
    }
  }

  Future<void> speak(String text) async {
    if (!_isEnabled) return;
    await init();
    
    // System TTS respects user's accessibility settings for rate/pitch
    // Only override if you have a specific reason:
    // await _flutterTts.setSpeechRate(0.5); // 0.0 to 1.0
    // await _flutterTts.setPitch(1.0); // 0.5 to 2.0
    
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> toggle(bool enabled) async {
    _isEnabled = enabled;
    if (!enabled) {
      await stop();
    }
  }

Future<void> loadTTSPreference() async {
  final prefs = await SharedPreferences.getInstance();
  _isEnabled = prefs.getBool('tts_enabled') ?? false;
}

Future<void> saveTTSPreference(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('tts_enabled', value);
  _isEnabled = value;

  if (!value) {
    await stop();
  }
}

  Future<void> dispose() async {
    await _flutterTts.stop();
    _isInitialized = false;
  }
}