import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';
import 'package:pedidosdp/page/list_pedidos.dart';
import 'package:pedidosdp/service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //https://187.85.164.196/api/comercial/v10/pedidoVenda?dataDigitacaoInicio=2026-06-16&dataDigitacaoFim=2026-06-16
  //modulo = comercial - serviço = Comercial v1.0

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ApiService _api;
  late Future<PaginatedResponsePedido<PedidoModel>> _futurePedidos;

  Future<void> _autenticar() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  @override
  void initState() {
    super.initState();
    _autenticar();
    _api = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5Mzc2MTQzMjgsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6Ik1WbkpKaGdGIiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.9s0aPo2hlN2xIVdc7pnazlUfU8t3m6C_864XHkv2XNQhU6lpE7vYCSyWb9Vf7lHvUTTEPsSdqwm5hBadArJYFQ',
    );
    _futurePedidos = _api.getListPedidos(
      2, // empresa
      '2026-06-18',
      '2026-06-18',
    );
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E5EB),
      endDrawer: Drawer(

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Cabeçalho do Menu'),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Ação do item
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FBFD),
        title: Text(
          'Consulta de Pedidos',
          style: TextStyle(
            color: const Color(0xFF0043AC),
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.info_outline, color: Color(0xFF0043AC)),
        //   ),
        // ],
      ),
      body: FutureBuilder<PaginatedResponsePedido<PedidoModel>>(
        future: _futurePedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final pedidos = snapshot.data!.data;
          return Column(
            children: [
              Text(pedidos.length.toString()),
              Expanded(child: PedidosScreen(pedidos: pedidos)),
            ],
          );
        },
      ),

      // body: PedidosScreen(
      //   pedidos: [
      //     PedidoModel(
      //       numero: 4082,
      //       dataHora: '12/06/2026',
      //       cliente: 'teste123',
      //       etapaColor: const Color(0xFFFE8D00),
      //       codEtapa: 3,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4083,
      //       dataHora: '13/06/2026',
      //       cliente: 'cliente2',
      //       etapaColor: const Color(0xFF0043AC),
      //       concluido: true,
      //       codEtapa: 4,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4084,
      //       dataHora: '14/06/2026',
      //       cliente: 'cliente3',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 5,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4085,
      //       dataHora: '15/06/2026',
      //       cliente: 'cliente4',
      //       etapaColor: const Color(0xFF0B1628),
      //       codEtapa: 9,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4086,
      //       dataHora: '16/06/2026',
      //       cliente: 'cliente5',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 4,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4087,
      //       dataHora: '17/06/2026',
      //       cliente: 'cliente6',
      //       etapaColor: const Color(0xFF0B1628),
      //       concluido: true,
      //       codEtapa: 9,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4088,
      //       dataHora: '18/06/2026',
      //       cliente: 'cliente7',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 4,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4089,
      //       dataHora: '19/06/2026',
      //       cliente: 'cliente8',
      //       etapaColor: const Color(0xFF0B1628),
      //       concluido: true,
      //       codEtapa: 9,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4090,
      //       dataHora: '20/06/2026',
      //       cliente: 'cliente9',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 5,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4091,
      //       dataHora: '21/06/2026',
      //       cliente: 'cliente10',
      //       etapaColor: const Color(0xFF0B1628),
      //       concluido: true,
      //       codEtapa: 9,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4092,
      //       dataHora: '22/06/2026',
      //       cliente: 'cliente11',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 3,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4093,
      //       dataHora: '23/06/2026',
      //       cliente: 'cliente12',
      //       etapaColor: const Color(0xFF0B1628),
      //       concluido: true,
      //       codEtapa: 9,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4094,
      //       dataHora: '24/06/2026',
      //       cliente: 'cliente13',
      //       etapaColor: const Color(0xFF677383),
      //       codEtapa: 5,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //     PedidoModel(
      //       numero: 4095,
      //       dataHora: '25/06/2026',
      //       cliente: 'cliente14',
      //       etapaColor: const Color(0xFF0B1628),
      //       concluido: true,
      //       codEtapa: 4,
      //       codCliente: 1,
      //       codPedido: '123456789',
      //       codRepresentante: 1,
      //       dataEmissao: '2026-06-16',
      //     ),
      //   ],
      // ),
    );
  }

  listaPedidos() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFF7FBFD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'N° Pedido',
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '4082',
                    style: TextStyle(
                      color: Color(0xFF0043AC),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'data / hora'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '12/06/2026',
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'teste123',
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sepearação & romaneio'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width / 6,
                    height: 6,
                    color: Color(0xFFFE8D00),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFFE8D00),
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF677383),
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
