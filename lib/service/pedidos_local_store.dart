import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Guarda, localmente no dispositivo, quais codigos de pedido o usuario ja
/// finalizou (clicou em "Finalizar" no Romaneio) -- mesmo que a API ainda nao
/// tenha propagado a mudanca real (situacao/codEtapa).
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

  /// Chamar quando o usuario clica em "Finalizar" no Romaneio.
  Future<void> marcarFinalizado(String codPedido) async {
    final set = await _lerSet();
    set.add(codPedido);
    await _salvarSet(set);
  }

  /// Chamar toda vez que a lista fresca vier da API (ja filtrada por
  /// precisaDeRomaneio). Remove do armazenamento local qualquer codigo
  /// que nao esta mais nessa lista -- ou seja, a API ja confirmou a
  /// mudanca de verdade (saiu de Digitado/etapa 3), entao nao precisa
  /// mais do disfarce local pra esse pedido.
  Future<void> limparConfirmados(Set<String> codigosAindaPendentesNaApi) async {
    final set = await _lerSet();
    set.removeWhere((cod) => !codigosAindaPendentesNaApi.contains(cod));
    await _salvarSet(set);
  }

  /// Aplica o status local (etapaRomaneioConcluidoLocal) nos pedidos que
  /// o usuario ja finalizou -- a lista de entrada ja deve vir filtrada
  /// (so pedidos com precisaDeRomaneio == true).
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