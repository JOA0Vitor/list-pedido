import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';
import 'package:pedidosdp/page/pedido_card.dart';

class PedidosScreen extends StatelessWidget {
  final List<Pedido> pedidos;

  const PedidosScreen({super.key, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: pedidos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        return PedidoCard(
          pedido: pedido,
          onTap: () {
            print('Pedido ${pedido.numero} selecionado');
          },
        );
      },
    );
  }
}