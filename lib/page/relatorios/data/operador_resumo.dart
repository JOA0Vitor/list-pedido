import 'package:pedidosdp/page/relatorios/relatorios_page.dart';
import 'package:pedidosdp/page/relatorios/widgets/pedido_mock.dart';

class OperadorResumo {
  const OperadorResumo({
    required this.nome,
    required this.totalPedidos,
    required this.eficiencia,
  });

  final String nome;
  final int totalPedidos;
  final double eficiencia; // 0 a 100
}

List<PedidoMock> _filtrarPorEmpresa(List<PedidoMock> pedidos, int empresaId) {
  return pedidos.where((p) => p.empresaId == empresaId).toList();
}

List<OperadorResumo> calcularResumoOperadores(
  List<PedidoMock> todosPedidos,
  Periodo periodo,
  int empresaId,
) {
   final hoje = DateTime.now();
  final inicio = hoje.subtract(Duration(days: periodo.dias));
  final pedidosDaEmpresa = _filtrarPorEmpresa(todosPedidos, empresaId);
  final pedidosNoPeriodo = pedidosDaEmpresa.where((p) => p.data.isAfter(inicio));

  final porOperador = <String, List<PedidoMock>>{};
  for (final pedido in pedidosNoPeriodo) {
    porOperador.putIfAbsent(pedido.operador, () => []).add(pedido);
  }

  final resumo = porOperador.entries.map((entry) {
    final total = entry.value.length;
    final concluidos = entry.value.where((p) => p.concluido).length;
    final eficiencia = total == 0 ? 0.0 : (concluidos / total) * 100;

    return OperadorResumo(
      nome: entry.key,
      totalPedidos: total,
      eficiencia: eficiencia,
    );
  }).toList();

  resumo.sort((a, b) => b.totalPedidos.compareTo(a.totalPedidos));
  return resumo;
}
