import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';

class PedidoCard extends StatelessWidget {
  final PedidoModel pedido;
  final VoidCallback? onTap;

  const PedidoCard({super.key, required this.pedido, this.onTap});

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
                color: pedido.etapaColor,
                codEtapa: pedido.codEtapa,
              ),
            ),
            const SizedBox(width: 20),
            _AcoesRow(concluido: pedido.concluido, codEtapa: pedido.codEtapa),
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
  final Color color;
  final int codEtapa;

  const _EtapaColumn({
    required this.color,
    required this.codEtapa,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          codEtapa == 3
              ? 'SEPARAÇÃO & ROMANEIO'
              : codEtapa == 4
              ? 'BIPAGEM & CONFERÊNCIA'
              : codEtapa == 5
              ? 'FATURAMENTO'
              : codEtapa == 9
              ? 'CARREGAMENTO CONCLUÍDO'
              : 'ERRO ;-;',
          // etapa.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF0B1628),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 6,
          color: codEtapa == 3
              ? Color(0xFF607d8b)
              : codEtapa == 4
              ? Color(0xFFFE8D00)
              : codEtapa == 5
              ? Color(0xFF4e2da2)
              : codEtapa == 9
              ? Color(0xFF3d7d24)
              : Color(0xFFFE8D00),
        ),
      ],
    );
  }
}

class _AcoesRow extends StatelessWidget {
  final bool concluido;
  final int codEtapa;

  const _AcoesRow({required this.concluido, required this.codEtapa});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          concluido ? Icons.check_circle : Icons.remove_circle_outline,
          color: codEtapa == 3
              ? Color(0xFF607d8b)
              : codEtapa == 4
              ? Color(0xFFFE8D00)
              : codEtapa == 5
              ? Color(0xFF4e2da2)
              : codEtapa == 9
              ? Color(0xFF3d7d24)
              : Color(0xFFFE8D00),
          size: 25,
        ),
        const SizedBox(width: 10),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF607d8b),
          size: 15,
        ),
      ],
    );
  }
}
