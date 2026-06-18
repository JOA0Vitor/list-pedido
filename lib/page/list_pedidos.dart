import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';
import 'package:pedidosdp/page/pedido_card.dart';
import 'package:pedidosdp/service/pedido_lock_service.dart';

class PedidosScreen extends StatelessWidget {
  final List<PedidoModel> pedidos;

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
          onTap: () async {
            // Scaffold.of(context).openDrawer();
            final lockService = PedidoLockService();
            const usuarioAtual =
                'user1'; 

            final usuarioEmUso = await lockService.usuarioEmUso(
              pedido.codPedido,
            );

            if (usuarioEmUso != null && usuarioEmUso != usuarioAtual) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Pedido em uso'),
                  content: Text('$usuarioEmUso já está nesse pedido.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }

            await lockService.travar(pedido.codPedido, usuarioAtual);

            // abre a tela de detalhe do pedido
            // await Navigator.push(...);

            // quando o usuário voltar da tela de detalhe, libera o pedido
            await lockService.destravar(pedido.codPedido);
          },
        );
      },
    );
  }
}
