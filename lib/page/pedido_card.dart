import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? onTap;

  const PedidoCard({
    super.key,
    required this.pedido,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _InfoColumn(
              label: 'N° Pedido',
              value: pedido.numero.toString(),
              valueStyle: const TextStyle(
                color: Color(0xFF0043AC),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            _InfoColumn(
              label: 'DATA / HORA',
              value: pedido.dataHora,
              valueStyle: const TextStyle(
                color: Color(0xFF0B1628),
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 14),
            _InfoColumn(
              label: 'CLIENTE',
              value: pedido.cliente,
              valueStyle: const TextStyle(
                color: Color(0xFF0B1628),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _EtapaColumn(
                etapa: pedido.etapa,
                color: pedido.etapaColor,
              ),
            ),
            const SizedBox(width: 20),
            _AcoesRow(concluido: pedido.concluido),
          ],
        ),
      ),
    );
  }
}


class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF677383),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _EtapaColumn extends StatelessWidget {
  final String etapa;
  final Color color;

  const _EtapaColumn({required this.etapa, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etapa.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF0B1628),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 6,
          color: color,
        ),
      ],
    );
  }
}

class _AcoesRow extends StatelessWidget {
  final bool concluido;

  const _AcoesRow({required this.concluido});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          concluido ? Icons.check_circle : Icons.check_circle_outline,
          color: const Color(0xFFFE8D00),
          size: 25,
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF677383),
          size: 15,
        ),
      ],
    );
  }
}