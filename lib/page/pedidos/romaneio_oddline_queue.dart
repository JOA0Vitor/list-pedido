import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RomaneioOfflineQueue {
  static const _prefixo = 'romaneio_pendente_sync_';

  Future<void> salvarPendente(String codPedido, List<String> chaves) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefixo$codPedido', jsonEncode(chaves));
  }

  Future<List<String>?> lerPendente(String codPedido) async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getString('$_prefixo$codPedido');
    if (salvo == null) return null;
    return (jsonDecode(salvo) as List).cast<String>();
  }

  Future<void> limparPendente(String codPedido) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefixo$codPedido');
  }
}