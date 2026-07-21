import 'package:flutter/material.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/page/corte/pedido_corte_card.dart';

class PedidosScreenCorte extends StatelessWidget {
  final List<CorteModel> pedidos;
  // final Map<int, String> nomesClientes;
  final int status;
  final void Function(CorteModel pedido) onPedidoTap;

  const PedidosScreenCorte({
    super.key,
    required this.pedidos,
    required this.status,
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
        return PedidoCorteCard(
          pedido: pedido,
          onTap: () async {
            print('tocou ${pedido.codPedido}');
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
