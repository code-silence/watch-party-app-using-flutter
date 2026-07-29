import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> tap() async {
    await _player.play(
      AssetSource('sounds/tap.mp3'),
    );
  }

  static Future<void> confirm() async {
    await _player.play(
      AssetSource('sounds/confirm.mp3'),
    );
  }
}