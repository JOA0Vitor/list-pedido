import 'package:flutter/material.dart';
import 'package:pedidosdp/page/relatorios/data/metricas_resumo.dart';
import 'package:pedidosdp/page/relatorios/widgets/metric_card.dart';
import 'package:pedidosdp/page/relatorios/widgets/trend_visual.dart';

class MetricasRow extends StatelessWidget {
  const MetricasRow({super.key, required this.metricas});

  final MetricasResumo metricas;

  @override
  Widget build(BuildContext context) {
    final totalTrend = trendVisualFromVariacao(metricas.variacaoTotalPercentual);
    final mediaTrend = trendVisualFromVariacao(metricas.variacaoMediaPercentual);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MetricCard(
            label: 'Total de pedidos',
            value: metricas.totalPedidos.toString(),
            icon: totalTrend.icon,
            color: totalTrend.color,
            message: totalTrend.message,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MetricCard(
            label: 'Média por operador',
            value: metricas.mediaPorOperador.toStringAsFixed(0),
            icon: mediaTrend.icon,
            color: mediaTrend.color,
            message: mediaTrend.message,
          ),
        ),
      ],
    );
  }
}