import 'package:audioplayers/audioplayers.dart';


class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playClick() async {
    await _player.play(AssetSource('sounds/click.mp3'));
  }
}
