import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/info_pedido.dart';
import 'package:pedidosdp/widgets/status_etapa.dart';

class PedidoCard extends StatelessWidget {
  final PedidoRecenteModel pedido;
  final VoidCallback? onTap;
 
  const PedidoCard({
    super.key,
    required this.pedido,
    this.onTap,
  });
 
  String _primeiroNome(String nome) {
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
              value: pedido.codPedido,
              valueStyle: const TextStyle(
                color: Color(0xFF0043AC),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            InfoColumn(
              label: 'DATA',
              value: formatarData(pedido.dataDigitacao),
              valueStyle: const TextStyle(
                color: Color(0xFF0B1628),
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 14),
            InfoColumn(
              label: 'CLIENTE',
              value: _primeiroNome(pedido.nomeCliente),
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
                color: PedidoRecenteModel.corPorEtapa(pedido.codEtapaExibicao!),
                codEtapa: pedido.codEtapaExibicao!,
              ),
            ),
            const SizedBox(width: 10),
            _AcoesRow(codEtapa: pedido.codEtapaExibicao!),
          ],
        ),
      ),
    );
  }
}

class _AcoesRow extends StatelessWidget {
  final int codEtapa;
 
  const _AcoesRow({required this.codEtapa});
 
  @override
  Widget build(BuildContext context) {
    final mostrarIcone = codEtapa != 4;
    final concluidoLocalmente =
        codEtapa == PedidoRecenteModel.etapaRomaneioConcluidoLocal;
 
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mostrarIcone
            ? Icon(
                concluidoLocalmente
                    ? Icons.check_circle
                    : Icons.remove_circle_outline,
                color: PedidoRecenteModel.corPorEtapa(codEtapa),
                size: 25,
              )
            : const SizedBox(),
        const SizedBox(width: 5),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF607d8b),
          size: 15,
        ),
      ],
    );
  }
}