import 'dart:math';

import 'package:pedidosdp/page/adm/api_configuracao/api_configuracao.dart';
import 'package:pedidosdp/page/adm/relatorios/relatorios_page.dart';
import 'package:pedidosdp/page/adm/relatorios/tendencia_pedidos_card.dart';

class PedidoMock {
  final DateTime data;
  final String operador;
  final bool concluido;
  final int empresaId;

  const PedidoMock({
    required this.data,
    required this.operador,
    this.concluido = false,
    required this.empresaId,
  });
}

List<PedidoMock> gerarPedidosMockados() {
  final hoje = DateTime.now();
  final operadoresCaruaru = [
    'Tarcicleiton',
    'Damião',
    'Gledson',
    'Bruno',
    'Douglas',
    'Guilherme',
    'Júnior',
    'Leandro',
    'João Victor',
    'Matheus',
  ];
  final operadoresSantaCruz = [
    'Fernanda',
    'Henrique',
    'Isabela',
    'Juliano',
    'Karen',
  ];
  final random = Random(42);
  final pedidos = <PedidoMock>[];

  for (final empresa in Empresa.values) {
    final operadores = empresa == Empresa.santaCruz
        ? operadoresSantaCruz
        : operadoresCaruaru;

    pedidos.addAll(
      List.generate(400, (i) {
        final diasAtras = random.nextInt(180);
        return PedidoMock(
          data: hoje.subtract(Duration(days: diasAtras)),
          operador: operadores[random.nextInt(operadores.length)],
          concluido: random.nextDouble() < 0.9,
          empresaId: empresa.id,
        );
      }),
    );
  }

  return pedidos;
}

List<PedidoMock> _filtrarPorEmpresa(List<PedidoMock> pedidos, int empresaId) {
  return pedidos.where((p) => p.empresaId == empresaId).toList();
}

List<PedidoPorDia> agruparPedidosPorDia(
  List<PedidoMock> todosPedidos,
  Periodo periodo,
  int empresaId,
) {
  final hoje = DateTime.now();
  final inicio = hoje.subtract(Duration(days: periodo.dias));
  final pedidosDaEmpresa = _filtrarPorEmpresa(todosPedidos, empresaId);

  final pedidosNoPeriodo = pedidosDaEmpresa.where((p) => p.data.isAfter(inicio));

  final contagemPorDia = <DateTime, int>{};
  for (final pedido in pedidosNoPeriodo) {
    final diaTruncado = DateTime(
      pedido.data.year,
      pedido.data.month,
      pedido.data.day,
    );
    contagemPorDia[diaTruncado] = (contagemPorDia[diaTruncado] ?? 0) + 1;
  }

  return [
    for (var i = periodo.dias - 1; i >= 0; i--)
      PedidoPorDia(
        data: DateTime(
          hoje.year,
          hoje.month,
          hoje.day,
        ).subtract(Duration(days: i)),
        quantidade:
            contagemPorDia[DateTime(
              hoje.year,
              hoje.month,
              hoje.day,
            ).subtract(Duration(days: i))] ??
            0,
      ),
  ];
}
