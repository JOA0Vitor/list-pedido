import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedidosdp/models/clientes_model.dart';
import 'package:pedidosdp/models/pedidos_model.dart';
import 'package:pedidosdp/page/list_pedidos.dart';
import 'package:pedidosdp/page/romaneio_page.dart';
import 'package:pedidosdp/service/api_service.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/info_pedido.dart';
import 'package:pedidosdp/widgets/status_etapa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //https://187.85.164.196/api/comercial/v10/pedidoVenda?dataDigitacaoInicio=2026-06-16&dataDigitacaoFim=2026-06-16
  //modulo = comercial - serviço = Comercial v1.0

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _emptyFocus = FocusNode();
  late final ApiService apiService;
  late Future<PaginatedResponsePedido<PedidoModel>> _futurePedidos;
  List<ClientesModel> _todos = [];
  List<ClientesModel> _filtrados = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  Future<void> _autenticar() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  Future<void> _fetchClientes() async {
    try {
      final result = await apiService.getClientes(1);
      print('Total clientes: ${result.data.length}');
      print(
        'Primeiro: ${result.data.first.nome} - ${result.data.first.codCliente}',
      );
      setState(() {
        _todos = result.data;
        _filtrados = result.data;
      });
    } catch (e) {
      print('ERRO: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emptyFocus);
    });
    _autenticar();
    _fetchClientes();
    apiService = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5Mzc2MTQzMjgsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6Ik1WbkpKaGdGIiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.9s0aPo2hlN2xIVdc7pnazlUfU8t3m6C_864XHkv2XNQhU6lpE7vYCSyWb9Vf7lHvUTTEPsSdqwm5hBadArJYFQ',
    );
    _futurePedidos = apiService.getListPedidos(
      2, // empresa
      '2026-06-19',
      '2026-06-19',
    );
  }

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFE0E5EB),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalhes do Pedido',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: InfoColumn(
                label: 'N° Pedido',
                value: 'pedido.codPedido',
                valueStyle: const TextStyle(
                  color: Color(0xFF0043AC),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoColumn(
                    label: 'DATA',
                    value: formatarData('2026-06-19'),
                    valueStyle: const TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  InfoColumn(
                    label: 'Checkout',
                    value: 'Em processo',
                    valueStyle: const TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: InfoColumn(
                label: 'CLIENTE',
                value: 'pedido.codCliente',
                valueStyle: const TextStyle(
                  color: Color(0xFF0B1628),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Etapa',
                      style: const TextStyle(
                        color: Color(0xFF677383),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    EtapaColumn(
                      color: Color(0xFFFE8D00),
                      // color: pedido.codEtapa == 3
                      //     ? Color(0xFFFE8D00)
                      //     : pedido.codEtapa == 4
                      //     ? Color(0xFF4CAF50)
                      //     : pedido.codEtapa == 5
                      //     ? Color(0xFF677383)
                      //     : pedido.codEtapa == 9
                      //     ? Color(0xFF9E9E9E)
                      //     : Color(0xFF2196F3),
                      codEtapa: 4,
                      // codEtapa: pedido.codEtapa,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RomaneioPage(codPedido: 'pedido.codPedido'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0043AC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Acompanhar Pedido',
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline, color: Color(0xFF0043AC)),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: RefreshIndicator(
          onRefresh: () async {
            // Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => HomePage(),
            //             ),
            //           );
            _futurePedidos = apiService.getListPedidos(
              2, // empresa
              '2026-06-19',
              '2026-06-19',
            );
          },
          child: FutureBuilder<PaginatedResponsePedido<PedidoModel>>(
            future: _futurePedidos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              final pedidos = snapshot.data!.data;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(pedidos.length.toString()),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Buscar cliente...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: PedidosScreen(
                        pedidos: pedidos,
                        onAbrirDrawer: () => scaffoldKey.currentState?.openEndDrawer(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
