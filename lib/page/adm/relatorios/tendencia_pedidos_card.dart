import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pedidosdp/page/adm/relatorios/relatorios_page.dart';

class TendenciaPedidosCard extends StatelessWidget {
  final List<PedidoPorDia> dados;
  final Periodo periodo;

  const TendenciaPedidosCard({
    super.key,
    required this.dados,
    required this.periodo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 163, 165, 167),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tendência de Pedidos (${periodo.dias} Dias)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: dados.isEmpty
                ? const Center(child: Text('Sem dados no período'))
                : _TendenciaLineChart(dados: dados),
          ),
        ],
      ),
    );
  }
}

class _TendenciaLineChart extends StatelessWidget {
  const _TendenciaLineChart({required this.dados});

  final List<PedidoPorDia> dados;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var i = 0; i < dados.length; i++)
        FlSpot(i.toDouble(), dados[i].quantidade.toDouble()),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (dados.length / 5).clamp(1, dados.length).toDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= dados.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    dados[index].diaLabel,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF0043AC),
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF0043AC).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class PedidoPorDia {
  const PedidoPorDia({required this.data, required this.quantidade});

  final DateTime data;
  final int quantidade;

  String get diaLabel =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
}

List<PedidoPorDia> gerarDadosMockados() {
  final hoje = DateTime.now();
  return List.generate(30, (i) {
    final dia = hoje.subtract(Duration(days: 29 - i));
    final quantidadeBase = 20 + (i % 7) * 3;
    return PedidoPorDia(data: dia, quantidade: quantidadeBase);
  });
}
