import 'package:flutter/material.dart';

class TrendVisual {
  const TrendVisual({required this.icon, required this.color, required this.message});

  final IconData icon;
  final Color color;
  final String message;
}

TrendVisual trendVisualFromVariacao(double variacaoPercentual) {
  if (variacaoPercentual.abs() < 1) {
    return const TrendVisual(
      icon: Icons.remove,
      color: Colors.grey,
      message: 'Compatível com o período anterior',
    );
  }

  final positivo = variacaoPercentual > 0;
  return TrendVisual(
    icon: positivo ? Icons.show_chart_rounded : Icons.trending_down_rounded,
    color: positivo ? const Color(0xD528A028) : const Color(0xD5C0392B),
    message:
        '${positivo ? '+' : ''}${variacaoPercentual.toStringAsFixed(1)}% vs período anterior',
  );
}