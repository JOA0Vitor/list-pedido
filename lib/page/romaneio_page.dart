import 'package:flutter/material.dart';

import '../service/api_service.dart';

class RomaneioPage extends StatefulWidget {
 final String codPedido;

  const RomaneioPage({super.key, required this.codPedido});

  @override
  State<RomaneioPage> createState() => _RomaneioPageState();
}

class _RomaneioPageState extends State<RomaneioPage> {
  late final ApiService _api;
  late Future<dynamic> _futureRomaneio;

  @override
  void initState() {
    super.initState();
    _api = ApiService(apiToken: 'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5Mzc2MTQzMjgsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6Ik1WbkpKaGdGIiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.9s0aPo2hlN2xIVdc7pnazlUfU8t3m6C_864XHkv2XNQhU6lpE7vYCSyWb9Vf7lHvUTTEPsSdqwm5hBadArJYFQ');
    _futureRomaneio =  _api.getRomaneioTextil(); // Substitua 1 pelo número da empresa correto
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Romaneio')),
      body: FutureBuilder<dynamic>(
        future: _futureRomaneio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final data = snapshot.data;
          // por enquanto só pra você ver a estrutura:
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(data.toString()),
          );
        },
      ),
    );
  }
}
