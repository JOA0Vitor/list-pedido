import 'package:flutter/material.dart';
import 'package:pedidosdp/page/pedidos/home_page.dart';
import 'package:pedidosdp/service/usuario_service.dart';

class SelecionarUsuarioPage extends StatelessWidget {
  const SelecionarUsuarioPage({super.key});

  Future<void> _selecionar(BuildContext context, String usuario) async {
    await UsuarioService.setUsuario(usuario);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Quem está usando este tablet?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selecionar(context, 'user1'),
              child: const Text('Usuário 1'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selecionar(context, 'user2'),
              child: const Text('Usuário 2'),
            ),
          ],
        ),
      ),
    );
  }
}