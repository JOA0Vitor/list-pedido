import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final _player = AudioPlayer();

  static Future<void> tocarAlerta() async {
    await _player.play(AssetSource('sounds/alerta.mp3'));
  }
}