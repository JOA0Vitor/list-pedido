import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/models/clientes_model.dart';
import 'package:pedidosdp/models/pedidos_model.dart';
import 'package:pedidosdp/page/list_pedidos.dart';
import 'package:pedidosdp/page/romaneio_page.dart';
import 'package:pedidosdp/service/api_service.dart';
import 'package:pedidosdp/service/notification_service.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/formatDataApi.dart';
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
  List<PedidoModel> _todosPedidos = [];
  Map<int, String> _nomesClientes = {};
  PedidoModel? _pedidoSelecionado;
  final _dataInicialController = TextEditingController();
  final _dataFinalController = TextEditingController();
  // List<PedidoModel> _pedidosFiltrados = [];
  List<PedidoModel> get _pedidosFiltrados {
    final termo = _searchController.text.toLowerCase();
    if (termo.isEmpty) return _todosPedidos;
    return _todosPedidos.where((p) {
      final nome = (_nomesClientes[p.codCliente] ?? '').toLowerCase();
      return p.codPedido.toLowerCase().contains(termo) || nome.contains(termo);
    }).toList();
  }

  Map<int, String>? _nomesClientesCache;
  Timer? _timer;
  Set<String> _codPedidosConhecidos = {};

  final List<String> _operadores = [
    'Gledson',
    'Damião',
    'Tarcicleiton',
    'Bruno',
    'Douglas',
    'Guilherme',
    'Júnior',
    'Leandro',
  ];

  String? _operadorSelecionado;

  late Future<List<dynamic>> _futureDados;

  Future<void> _autenticar() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  void _filtrar() {
    setState(() {});
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
      print('ERRO HOME: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // final _formatDataApi = FormatDataApi();

  String _formatarHojeParaApi() {
    final hoje = DateTime.now();
    return '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
  }

  String _converterBrParaApi(String dataBr) {
    final partes = dataBr.split('/'); // [dd, MM, yyyy]
    return '${partes[2]}-${partes[1]}-${partes[0]}';
  }

  String _formatarHojeParaExibir() {
    final hoje = DateTime.now();
    return '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';
  }

  void _buscarPedidos() {
    final dataInicialApi = _dataInicialController.text.isEmpty
        ? _formatarHojeParaApi()
        : _converterBrParaApi(_dataInicialController.text);
    final dataFinalApi = _dataFinalController.text.isEmpty
        ? _formatarHojeParaApi()
        : _converterBrParaApi(_dataFinalController.text);

    setState(() {
      _futureDados = _buscarTudo(dataInicialApi, dataFinalApi);
    });
  }

  Future<List<dynamic>> _buscarTudo(String inicio, String fim) async {
    final pedidosResponse = await apiService.getListPedidos(2, inicio, fim);

    // só busca clientes na primeira vez (cache)
    if (_nomesClientesCache == null) {
      final clientesResponse = await apiService.getClientes(2);
      _nomesClientesCache = {
        for (final c in clientesResponse.data) c.codCliente.toInt(): c.nome,
      };
    }

    return [pedidosResponse, _nomesClientesCache!];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emptyFocus);
    });

    apiService = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5Mzc2MTQzMjgsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6Ik1WbkpKaGdGIiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.9s0aPo2hlN2xIVdc7pnazlUfU8t3m6C_864XHkv2XNQhU6lpE7vYCSyWb9Vf7lHvUTTEPsSdqwm5hBadArJYFQ',
    );

    final hoje = _formatarHojeParaExibir();
    _dataInicialController.text = hoje;
    _dataFinalController.text = hoje;

    _buscarPedidos();

    _searchController.addListener(() => setState(() {}));
    _autenticar();
    _fetchClientes();

    _timer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _buscarPedidos(),
    );

    _iniciarTimer();
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await _verificarNovoPedidos();
    });
  }

  Future<void> _verificarNovoPedidos() async {
    try {
      final dataInicialApi = _converterBrParaApi(_dataInicialController.text);
      final dataFinalApi = _converterBrParaApi(_dataFinalController.text);
      final response = await apiService.getListPedidos(
        2,
        dataInicialApi,
        dataFinalApi,
      );

      final codsPedidosNovos = response.data.map((p) => p.codPedido).toSet();

      debugPrint('--- TIMER VERIFICOU ---');
      debugPrint('Conhecidos: $_codPedidosConhecidos');
      debugPrint('Retornados: $codsPedidosNovos');

      if (_codPedidosConhecidos.isEmpty) {
        _codPedidosConhecidos = codsPedidosNovos;
        debugPrint('Primeira vez — só registrou, sem notificar');
        return;
      }

      final chegaram = codsPedidosNovos.difference(_codPedidosConhecidos);
      debugPrint('Novos detectados: $chegaram');

      if (chegaram.isNotEmpty) {
        _codPedidosConhecidos = codsPedidosNovos;
        debugPrint('NOVO PEDIDO — disparando som');
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await NotificationService.tocarAlerta();
        });
        _buscarPedidos();
      }
    } catch (e) {
      debugPrint('Erro ao verificar novos pedidos: $e');
    }
  }

  // void _buscarPedidos() {
  //   final dataInicialApi = _dataInicialController.text.isEmpty
  //       ? _formatarHojeParaApi()
  //       : _converterBrParaApi(_dataInicialController.text);

  //   final dataFinalApi = _dataFinalController.text.isEmpty
  //       ? _formatarHojeParaApi()
  //       : _converterBrParaApi(_dataFinalController.text);

  //   print('_buscarPedidos dataInicialApi: $dataInicialApi');
  //   print('_buscarPedidos dataFinalApi: $dataFinalApi');
  //   setState(() {
  //     _futureDados = Future.wait([
  //       apiService.getListPedidos(2, dataInicialApi, dataFinalApi),
  //       apiService.getClientes(2),
  //     ]);
  //   });
  // }

  @override
  void dispose() {
    apiService.dispose();
    _searchController.removeListener(_filtrar);
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFE0E5EB),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: _pedidoSelecionado == null
            ? const Center(child: Text('Nenhum pedido selecionado'))
            : ListView(
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
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: InfoColumn(
                      label: 'N° Pedido',
                      value: _pedidoSelecionado!.codPedido,
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
                          value: formatarData(_pedidoSelecionado!.dataEmissao),
                          valueStyle: const TextStyle(
                            color: Color(0xFF0B1628),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        InfoColumn(
                          label: 'Checkout',
                          value: _pedidoSelecionado!.codEtapa == 4
                              ? 'Em processo'
                              : '',
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
                    //erro no realese
                    title: InfoColumn(
                      label: 'CLIENTE',
                      value:
                          _nomesClientes[_pedidoSelecionado!.codCliente] ?? '',
                      valueStyle: const TextStyle(
                        color: Color(0xFF0B1628),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
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
                                color: PedidoModel.corPorEtapa(
                                  _pedidoSelecionado!.codEtapa,
                                ),
                                codEtapa: _pedidoSelecionado!.codEtapa,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_pedidoSelecionado!.codEtapa == 4)
                    Column(
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'OPERADOR',
                                style: TextStyle(
                                  color: Color(0xFF677383),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _operadorSelecionado,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Selecione o operador',
                                ),
                                items: _operadores
                                    .map(
                                      (op) => DropdownMenuItem(
                                        value: op,
                                        child: Text(op),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (valor) {
                                  setState(() => _operadorSelecionado = valor);
                                  // futuramente: lockService.travar(_pedidoSelecionado!.codPedido, valor!);
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RomaneioPage(
                                    codPedido: _pedidoSelecionado!.codPedido,
                                  ),
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
                        ListTile(
                          title: Text(
                            'Colocar uma condição no botao',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => NotificationService.tocarAlerta(),
              child: const Text('Testar notificação'),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
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
                      const SizedBox(width: 10),
                      InfoColumn(
                        label: 'Total de Pedidos',
                        value: _pedidosFiltrados.length.toString(),
                        valueStyle: const TextStyle(
                          color: Color(0xFF0043AC),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _dataInicialController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Data inicial',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () async {
                                final dataSelecionada = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (dataSelecionada != null) {
                                  _dataInicialController.text =
                                      "${dataSelecionada.day.toString().padLeft(2, '0')}/"
                                      "${dataSelecionada.month.toString().padLeft(2, '0')}/"
                                      "${dataSelecionada.year}";
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _dataFinalController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Data final',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () async {
                                final dataSelecionada = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (dataSelecionada != null) {
                                  _dataFinalController.text =
                                      "${dataSelecionada.day.toString().padLeft(2, '0')}/"
                                      "${dataSelecionada.month.toString().padLeft(2, '0')}/"
                                      "${dataSelecionada.year}";
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _buscarPedidos,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(108, 55),
                          backgroundColor: const Color(0xFF0043AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Filtrar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // _buscarPedidos();
                  _timer = Timer.periodic(
                    const Duration(minutes: 1),
                    (_) => _buscarPedidos(),
                  );
                },
                child: FutureBuilder<List<dynamic>>(
                  future: _futureDados,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Erro: ${snapshot.error}'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _buscarPedidos,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    final pedidosResponse =
                        snapshot.data![0]
                            as PaginatedResponsePedido<PedidoModel>;
                    final nomesClientes = snapshot.data![1] as Map<int, String>;

                    _todosPedidos = pedidosResponse.data;
                    _nomesClientes = nomesClientes;

                    if (_todosPedidos.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum pedido encontrado',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PedidosScreen(
                        pedidos: _pedidosFiltrados,
                        nomesClientes: _nomesClientes,
                        onPedidoTap: (pedido) {
                          setState(() {
                            _pedidoSelecionado = pedido;
                            _operadorSelecionado = null;
                          });
                          scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // body: PopScope(
      //   canPop: false,
      //   child: RefreshIndicator(
      //     onRefresh: () async {
      //       // Navigator.of(context).push(
      //       //             MaterialPageRoute(
      //       //               builder: (context) => HomePage(),
      //       //             ),
      //       //           );
      //       // _buscarPedidos();
      //        _timer = Timer.periodic(const Duration(minutes: 2), (_) => _buscarPedidos());
      //     },
      //     child: FutureBuilder<List<dynamic>>(
      //       future: _futureDados,
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return const Center(child: CircularProgressIndicator());
      //         }
      //         if (snapshot.hasError) {
      //           return Center(child: Text('Erro FUTURE: ${snapshot.error}'));
      //         }
      //         if (snapshot.data![0].data.isEmpty) {
      //           return Center(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 const Text(
      //                   'Nenhum pedido',
      //                   style: TextStyle(
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 20,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 10),

      //                 ElevatedButton(
      //                   //verificar esse botão
      //                   onPressed: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) =>
      //                             PopScope(canPop: false, child: HomePage()),
      //                       ),
      //                     );
      //                   },
      //                   style: ElevatedButton.styleFrom(
      //                     minimumSize: const Size(108, 55),
      //                     backgroundColor: const Color(0xFF0043AC),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(8),
      //                     ),
      //                   ),
      //                   child: const Text(
      //                     'Voltar',
      //                     style: TextStyle(color: Colors.white),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         }

      //         final pedidosResponse =
      //             snapshot.data![0] as PaginatedResponsePedido<PedidoModel>;
      //         final clientesResponse =
      //             snapshot.data![1] as PaginatedResponseClientes<ClientesModel>;

      //         _todosPedidos = pedidosResponse.data;
      //         _nomesClientes = {
      //           for (final c in clientesResponse.data)
      //             c.codCliente.toInt(): c.nome,
      //         };

      //         return Padding(
      //           padding: const EdgeInsets.all(16),
      //           child: Column(
      //             children: [
      //               Container(
      //                 height: 150,
      //                 padding: const EdgeInsets.all(12),
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //                 child: Column(
      //                   children: [
      //                     Row(
      //                       children: [
      //                         Expanded(
      //                           flex: 3,
      //                           child: TextFormField(
      //                             controller: _searchController,
      //                             autofocus: true,
      //                             decoration: InputDecoration(
      //                               hintText: 'Buscar cliente...',
      //                               prefixIcon: const Icon(Icons.search),
      //                               suffixIcon:
      //                                   _searchController.text.isNotEmpty
      //                                   ? IconButton(
      //                                       icon: const Icon(Icons.clear),
      //                                       onPressed: () =>
      //                                           _searchController.clear(),
      //                                     )
      //                                   : null,
      //                               border: OutlineInputBorder(
      //                                 borderRadius: BorderRadius.circular(8),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         const SizedBox(width: 10),
      //                         InfoColumn(
      //                           label: 'Total de Pedidos',
      //                           value: _pedidosFiltrados.length.toString(),
      //                           valueStyle: const TextStyle(
      //                             color: Color(0xFF0043AC),
      //                             fontWeight: FontWeight.bold,
      //                             fontSize: 20,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     const SizedBox(height: 12),
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Expanded(
      //                           flex: 3,
      //                           child: TextFormField(
      //                             controller: _dataInicialController,
      //                             readOnly: true,
      //                             decoration: InputDecoration(
      //                               hintText: 'Data inicial',
      //                               suffixIcon: IconButton(
      //                                 icon: const Icon(Icons.calendar_month),
      //                                 onPressed: () async {
      //                                   DateTime? dataSelecionada =
      //                                       await showDatePicker(
      //                                         context: context,
      //                                         initialDate: DateTime.now(),
      //                                         firstDate: DateTime(2000),
      //                                         lastDate: DateTime(2100),
      //                                       );

      //                                   if (dataSelecionada != null) {
      //                                     _dataInicialController.text =
      //                                         "${dataSelecionada.day.toString().padLeft(2, '0')}/"
      //                                         "${dataSelecionada.month.toString().padLeft(2, '0')}/"
      //                                         "${dataSelecionada.year}";
      //                                   }
      //                                 },
      //                               ),
      //                               border: OutlineInputBorder(
      //                                 borderRadius: BorderRadius.circular(8),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         const SizedBox(width: 10),
      //                         Expanded(
      //                           flex: 3,
      //                           child: TextFormField(
      //                             controller: _dataFinalController,
      //                             readOnly: true,
      //                             decoration: InputDecoration(
      //                               hintText: 'Data final',
      //                               suffixIcon: IconButton(
      //                                 icon: const Icon(Icons.calendar_month),
      //                                 onPressed: () async {
      //                                   DateTime? dataSelecionada =
      //                                       await showDatePicker(
      //                                         context: context,
      //                                         initialDate: DateTime.now(),
      //                                         firstDate: DateTime(2000),
      //                                         lastDate: DateTime(2100),
      //                                       );

      //                                   if (dataSelecionada != null) {
      //                                     _dataFinalController.text =
      //                                         "${dataSelecionada.day.toString().padLeft(2, '0')}/"
      //                                         "${dataSelecionada.month.toString().padLeft(2, '0')}/"
      //                                         "${dataSelecionada.year}";
      //                                   }
      //                                 },
      //                               ),

      //                               border: OutlineInputBorder(
      //                                 borderRadius: BorderRadius.circular(8),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         const SizedBox(width: 10),
      //                         ElevatedButton(
      //                           onPressed: _buscarPedidos,
      //                           style: ElevatedButton.styleFrom(
      //                             minimumSize: Size(108, 55),
      //                             backgroundColor: const Color(0xFF0043AC),
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                             ),
      //                           ),
      //                           child: const Text(
      //                             'Filtrar',
      //                             style: TextStyle(color: Colors.white),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //               Expanded(
      //                 child: PedidosScreen(
      //                   // pedidos: pedidosResponse.data,
      //                   // pedidos: _todosPedidos,
      //                   pedidos: _pedidosFiltrados,
      //                   nomesClientes: _nomesClientes,
      //                   onPedidoTap: (pedido) {
      //                     setState(() {
      //                       _pedidoSelecionado = pedido;
      //                       _operadorSelecionado = null;
      //                     });
      //                     scaffoldKey.currentState?.openEndDrawer();
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
