import 'package:pedidosdp/page/adm/relatorios/relatorios_page.dart';
import 'package:pedidosdp/page/adm/relatorios/widgets/pedido_mock.dart';

class MetricasResumo {
  const MetricasResumo({
    required this.totalPedidos,
    required this.mediaPorOperador,
    required this.variacaoTotalPercentual,
    required this.variacaoMediaPercentual,
  });

  final int totalPedidos;
  final double mediaPorOperador;
  final double variacaoTotalPercentual;
  final double variacaoMediaPercentual;
}

List<PedidoMock> _filtrarPorEmpresa(List<PedidoMock> pedidos, int empresaId) {
  return pedidos.where((p) => p.empresaId == empresaId).toList();
}

MetricasResumo calcularMetricas(
  List<PedidoMock> todosPedidos,
  Periodo periodo,
  int empresaId,
) {
  final hoje = DateTime.now();
  final inicioAtual = hoje.subtract(Duration(days: periodo.dias));
  final inicioAnterior = hoje.subtract(Duration(days: periodo.dias * 2));
  final pedidosDaEmpresa = _filtrarPorEmpresa(todosPedidos, empresaId);

  final periodoAtual = pedidosDaEmpresa
      .where((p) => p.data.isAfter(inicioAtual))
      .toList();
  final periodoAnterior = pedidosDaEmpresa
      .where(
        (p) => p.data.isAfter(inicioAnterior) && p.data.isBefore(inicioAtual),
      )
      .toList();

  final totalAtual = periodoAtual.length;
  final totalAnterior = periodoAnterior.length;

  final operadoresAtual = periodoAtual.map((p) => p.operador).toSet();
  final mediaAtual = operadoresAtual.isEmpty
      ? 0.0
      : totalAtual / operadoresAtual.length;

  final operadoresAnterior = periodoAnterior.map((p) => p.operador).toSet();
  final mediaAnterior = operadoresAnterior.isEmpty
      ? 0.0
      : totalAnterior / operadoresAnterior.length;

  double variacao(num atual, num anterior) {
    if (anterior == 0) return atual == 0 ? 0 : 100;
    return ((atual - anterior) / anterior) * 100;
  }

  return MetricasResumo(
    totalPedidos: totalAtual,
    mediaPorOperador: mediaAtual,
    variacaoTotalPercentual: variacao(totalAtual, totalAnterior),
    variacaoMediaPercentual: variacao(mediaAtual, mediaAnterior),
  );
}
