import 'package:flutter/material.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/page/corte/agenda_pedido_dialog.dart';
import 'package:pedidosdp/page/corte/pedido_corte_card.dart';

class PedidosScreenCorte extends StatelessWidget {
  final List<CorteModel> pedidos;
  final int status;
  final void Function(CorteModel pedido) onPedidoTap;
  final void Function(CorteModel pedido, AgendamentoResult resultado) onAgendar;

  const PedidosScreenCorte({
    super.key,
    required this.pedidos,
    required this.status,
    required this.onPedidoTap,
    required this.onAgendar,
  });

  @override
  Widget build(BuildContext context) {
    final pedidosOrdenados = [...pedidos]
      ..sort((a, b) => b.codPedido.compareTo(a.codPedido));

    return ListView.separated(
      itemCount: pedidosOrdenados.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final pedido = pedidosOrdenados[index];
        return PedidoCorteCard(
          pedido: pedido,
          onTap: () async {
            print('tocou ${pedido.codPedido} status ${pedido.status}');
            if (pedido.status == 1) {
              _showAgendarDialog(context, pedido); 
            }
          },
        );
      },
    );
  }

  Future<void> _showAgendarDialog(
    BuildContext context,
    CorteModel pedido,
  ) async {
    final resultado = await showDialog<AgendamentoResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AgendarPedidoDialog(pedido: pedido),
    );

    if (resultado != null) {
      onAgendar(pedido, resultado);
    }
  }
}
