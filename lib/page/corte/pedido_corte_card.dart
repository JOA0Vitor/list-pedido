// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/info_pedido.dart';

class PedidoCorteCard extends StatelessWidget {
  final CorteModel pedido;
  final VoidCallback? onTap;

  const PedidoCorteCard({super.key, required this.pedido, this.onTap});

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
            Expanded(
              flex: 2,
              child: InfoColumn(
                label: 'N° Pedido'.toUpperCase(),
                value: pedido.codPedido.toString(),
                valueStyle: const TextStyle(
                  color: Color(0xFF0043AC),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: InfoColumn(
                label: 'DATA',
                value: formatarData(pedido.dataEmissao),
                valueStyle: const TextStyle(
                  color: Color(0xFF0B1628),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // InfoColumn(
            //   label: 'CLIENTE - ${pedido.codEtapa}',
            //   // value: pedido.codCliente.toString(),
            //   // value: '',
            //   value: nomeCliente == ''
            //       ? _primeirosDoisNomes(nomeCliente)
            //       : 'Ver mais',
            //   valueStyle: const TextStyle(
            //     color: Color(0xFF0B1628),
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //   ),
            // ),
            const SizedBox(width: 50),
            Expanded(
              flex: 4,
              child: EtapaColumn(
                color: pedido.status == 1
                    ? Color(0xFFFE8D00)
                    : Color(0xFF4CAF50),
                codEtapa: pedido.status,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _AcoesRow(
                concluido: pedido.status == 4,
                codEtapa: pedido.status,
                isOpen: pedido.status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EtapaColumn extends StatelessWidget {
  final Color color;
  final int codEtapa;

  const EtapaColumn({super.key, required this.color, required this.codEtapa});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STATUS',
          style: const TextStyle(
            color: Color(0xFF677383),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: codEtapa == 1
                ? Color(0xFFFE8D00).withOpacity(0.2)
                : Color(0xFF3d7d24).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                codEtapa == 1
                    ? Icons.remove_circle_outline
                    : Icons.check_circle_outline_outlined,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                codEtapa == 1 ? 'A FAZER' : 'CARREGAMENTO CONCLUÍDO',
                // etapa.toUpperCase(),
                style: TextStyle(
                  color: codEtapa == 1 ? Color(0xFFFE8D00) : Color(0xFF3d7d24),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AcoesRow extends StatelessWidget {
  final bool concluido;
  final int codEtapa;
  final int isOpen;

  const _AcoesRow({
    required this.concluido,
    required this.codEtapa,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return isOpen == 1 && isOpen != 4
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ações'.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF677383),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),

              Icon(
                Icons.remove_red_eye_outlined,
                color: Color(0xFF0043AC),
                size: 25,
              ),
            ],
          )
        : SizedBox();
  }
}
