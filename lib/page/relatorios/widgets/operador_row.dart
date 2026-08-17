import 'package:flutter/material.dart';
import 'package:pedidosdp/page/relatorios/data/operador_resumo.dart';

class OperadorRow extends StatelessWidget {
  const OperadorRow({super.key, required this.operador, required this.zebra});

  final OperadorResumo operador;
  final bool zebra;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: zebra ? const Color(0xFFFAFBFC) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _verticalDividerRow(),
          _dataCell(operador.nome, flex: 2),
          _verticalDividerRow(),
          _dataCell(operador.totalPedidos.toString(), flex: 6),
          _verticalDividerRow(),
          _dataCell(
            '${operador.eficiencia.toStringAsFixed(1)}%',
            flex: 2,
            center: true,
            bold: true,
          ),
          _verticalDividerRow(),
        ],
      ),
    );
  }

  Widget _verticalDividerRow() {
    return Container(width: 1.0, height: 16, color: Color(0xFFDEE2E6));
  }

  Widget _dataCell(
    String text, {
    required int flex,
    bool center = false,
    bool right = false,
    bool isCode = false,
    bool bold = false,
    bool muted = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          textAlign: center
              ? TextAlign.center
              : right
              ? TextAlign.right
              : TextAlign.left,
          style: TextStyle(
            fontSize: isCode ? 11 : 12,
            fontFamily: isCode ? 'monospace' : null,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: muted ? const Color(0xFFADB5BD) : const Color(0xFF212529),
          ),
        ),
      ),
    );
  }
}
