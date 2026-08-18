import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/page/pedidos/pedido_card.dart';

class PedidosScreen extends StatelessWidget {
  final List<PedidoRecenteModel> pedidos;
    final void Function(PedidoRecenteModel pedido) onPedidoTap;


  const PedidosScreen({
    super.key,
    required this.pedidos,
    required this.onPedidoTap,
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
        return PedidoCard(
          pedido: pedido,
          onTap: () async {
            print('tocou lista ${pedido.codPedido}');
            onPedidoTap(pedido);
          },
        );
      },
    );
  }
}
