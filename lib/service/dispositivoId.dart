import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class DispositivoId {
  static const _chave = 'dispositivo_id';
  static String? _cache;

  static Future<String> obter() async {
    if (_cache != null) return _cache!;

    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_chave);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_chave, id);
    }
    _cache = id;
    return id;
  }
}