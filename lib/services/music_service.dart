import 'package:audioplayers/audioplayers.dart';

class MusicService {
  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;

  Future<void> play(String fileName) async {
    await player.stop();
    await player.play(AssetSource('music/$fileName'));
    isPlaying = true;
  }

  Future<void> pause() async {
    await player.pause();
    isPlaying = false;
  }

  Future<void> resume() async {
    await player.resume();
    isPlaying = true;
  }

  Future<void> stop() async {
    await player.stop();
    isPlaying = false;
  }

  Future<void> dispose() async {
    await player.dispose();
  }
}