import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> tap() async {
    await _player.play(
      AssetSource('sounds/tap.mp3'),
      volume: 0.2,
    );
  }

  static Future<void> confirm() async {
    await _player.play(
      AssetSource('sounds/confirm.mp3'),
    );
  }
  
  static Future<void> trigger() async {
    await _player.play(
      AssetSource('sounds/ui_tap.mp3'),
      volume: 1.0,
    );
  }

}