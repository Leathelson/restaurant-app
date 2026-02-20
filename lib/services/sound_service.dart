import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;

  // Initialize the player (call once at app startup)
  static Future<void> initialize() async {
    if (!_isInitialized) {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(1.0); // 30% volume (adjust as needed)
      _isInitialized = true;
    }
  }

  // Play click sound
  static Future<void> playClick() async {
    try {
      await _player.play(
        AssetSource('audiosfx/click.mp3'),
        volume: 1.0,
      );
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Play success sound (optional - for favorites, etc.)
  static Future<void> playSuccess() async {
    try {
      await _player.play(
        AssetSource('audiosfx/click.mp3'), // Add this sound if you want
        volume: 1.0,
      );
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Dispose when app closes
  static void dispose() {
    _player.dispose();
  }
}