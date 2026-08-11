import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static Future<void> tocarAlerta() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/new_alerta.mp3'));
  }
}
