import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos_model.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/info_pedido.dart';
import 'package:pedidosdp/widgets/status_etapa.dart';

class PedidoCard extends StatelessWidget {
  final PedidoModel pedido;
  final String nomeCliente;
  final VoidCallback? onTap;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.nomeCliente,
    this.onTap,
  });

  String _primeirosDoisNomes(String nome) {
    final partes = nome.trim().split(' ');
    return partes.take(1).join(' ');
  }

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
            InfoColumn(
              label: 'N° Pedido',
              value: pedido.codPedido.toString(),
              valueStyle: const TextStyle(
                color: Color(0xFF0043AC),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            InfoColumn(
              label: 'DATA',

              /// HORA
              value: formatarData(pedido.dataEmissao),
              valueStyle: const TextStyle(
                color: Color(0xFF0B1628),
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 14),
            InfoColumn(
              label: 'CLIENTE',
              // value: pedido.codCliente.toString(),
              // value: '',
              value: nomeCliente == ''
                  ? _primeirosDoisNomes(nomeCliente)
                  : 'Ver mais',
              valueStyle: const TextStyle(
                color: Color(0xFF0B1628),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 50),
            Expanded(
              flex: 5,
              child: EtapaColumn(
                color: pedido.codEtapa == 3
                    ? Color(0xFFFE8D00)
                    : pedido.codEtapa == 4
                    ? Color(0xFF4CAF50)
                    : pedido.codEtapa == 5
                    ? Color(0xFF677383)
                    : pedido.codEtapa == 9
                    ? Color(0xFF9E9E9E)
                    : Color(0xFF2196F3),
                codEtapa: pedido.codEtapa,
              ),
            ),
            const SizedBox(width: 10),
            _AcoesRow(
              concluido: pedido.codEtapa == 4,
              codEtapa: pedido.codEtapa,
              isOpen: pedido.codEtapa,
            ),
          ],
        ),
      ),
    );
  }
}

// class InfoColumn extends StatelessWidget {
//   final String label;
//   final String value;
//   final TextStyle valueStyle;

//   const InfoColumn({
//     required this.label,
//     required this.value,
//     required this.valueStyle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF677383),
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         Text(value, style: valueStyle),
//       ],
//     );
//   }
// }

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isOpen != 3 && isOpen != 5
            ? Icon(
                concluido ? Icons.remove_circle_outline : Icons.check_circle,
                color: PedidoModel.corPorEtapa(codEtapa),
                size: 25,
              )
            : SizedBox(),
        const SizedBox(width: 5),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF607d8b),
          size: 15,
        ),
      ],
    );
  }
}
