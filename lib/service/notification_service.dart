import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static Future<void> tocarAlerta() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/alerta.mp3'));
  }
}