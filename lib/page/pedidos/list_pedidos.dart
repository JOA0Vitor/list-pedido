import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/page/pedidos/pedido_card.dart';

class PedidosScreen extends StatelessWidget {
  final List<PedidoRecenteModel> pedidos;
  // final Map<int, String> nomesClientes;
    final void Function(PedidoRecenteModel pedido) onPedidoTap;


  const PedidosScreen({
    super.key,
    required this.pedidos,
    // required this.nomesClientes,
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
          // nomeCliente: pedido.nomeCliente,
          onTap: () async {
            print('tocou lista ${pedido.codPedido}');
            onPedidoTap(pedido);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         RomaneioPage(codPedido: pedido.codPedido),
            //   ),
            // );
            // Scaffold.of(context).openDrawer();
            // final lockService = PedidoLockService();
            // const usuarioAtual = 'user1';

            // final usuarioEmUso = await lockService.usuarioEmUso(
            //   pedido.codPedido,
            // );

            // if (usuarioEmUso != null && usuarioEmUso != usuarioAtual) {
            //   showDialog(
            //     context: context,
            //     builder: (_) => AlertDialog(
            //       title: const Text('Pedido em uso'),
            //       content: Text('$usuarioEmUso já está nesse pedido.'),
            //       actions: [
            //         TextButton(
            //           onPressed: () => Navigator.pop(context),
            //           child: const Text('OK'),
            //         ),
            //       ],
            //     ),
            //   );
            //   return;
            // }

            // await lockService.travar(pedido.codPedido, usuarioAtual);

            // // abre a tela de detalhe do pedido
            // // await Navigator.push(...);

            // // quando o usuário voltar da tela de detalhe, libera o pedido
            // await lockService.destravar(pedido.codPedido);
          },
        );
      },
    );
  }
}
