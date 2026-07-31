import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosLocalStore {
  static const _chave = 'pedidos_finalizados_localmente';

  Future<Set<String>> _lerSet() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_chave) ?? [];
    return lista.toSet();
  }

  Future<void> _salvarSet(Set<String> set) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chave, set.toList());
  }

  Future<void> marcarFinalizado(String codPedido) async {
    final set = await _lerSet();
    set.add(codPedido);
    await _salvarSet(set);
  }

  Future<void> limparConfirmados(Set<String> codigosAindaPendentesNaApi) async {
    final set = await _lerSet();
    set.removeWhere((cod) => !codigosAindaPendentesNaApi.contains(cod));
    await _salvarSet(set);
  }

  Future<List<PedidoRecenteModel>> aplicarOverrides(
    List<PedidoRecenteModel> pedidosPendentes,
  ) async {
    final finalizadosLocalmente = await _lerSet();

    return pedidosPendentes.map((pedido) {
      if (finalizadosLocalmente.contains(pedido.codPedido)) {
        return pedido.copyWith(
          codEtapa: PedidoRecenteModel.etapaRomaneioConcluidoLocal,
        );
      }
      return pedido;
    }).toList();
  }
}