import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  static const _chave = 'usuario_atual';

  static Future<String?> getUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chave);
  }

  static Future<void> setUsuario(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, usuario);
  }
}