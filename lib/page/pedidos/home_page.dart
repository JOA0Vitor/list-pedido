import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/page/pedidos/list_pedidos.dart';
import 'package:pedidosdp/page/pedidos/romaneio_page.dart';
import 'package:pedidosdp/page/selecao_perfil_page.dart';
import 'package:pedidosdp/service/api_service.dart';
import 'package:pedidosdp/service/notification_service.dart';
import 'package:pedidosdp/service/pedidos_local_store.dart';
import 'package:pedidosdp/widgets/formatData.dart';
import 'package:pedidosdp/widgets/info_pedido.dart';
import 'package:pedidosdp/widgets/status_etapa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _emptyFocus = FocusNode();
  final _searchController = TextEditingController();
  final _localStore = PedidosLocalStore();

  late final ApiService apiService;
  late Future<List<PedidoRecenteModel>> _futurePedidos;

  List<PedidoRecenteModel> _todosPedidos = [];
  PedidoRecenteModel? _pedidoSelecionado;
  String? _operadorSelecionado;
  Timer? _timer;
  Set<String> _codPedidosConhecidos = {};

  static const int _codEmpresa = 2;

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

  List<PedidoRecenteModel> get _pedidosFiltrados {
    final termo = _searchController.text.toLowerCase();
    if (termo.isEmpty) return _todosPedidos;
    return _todosPedidos.where((p) {
      return p.codPedido.toLowerCase().contains(termo) ||
          p.nomeCliente.toLowerCase().contains(termo);
    }).toList();
  }

  Future<List<PedidoRecenteModel>> _buscarPedidosParaExibir() async {
    final resposta = await apiService.getPedidosRecentes(
      _codEmpresa,
      limite: 100,
    );

    final pendentes = resposta.pedidos
        .where((p) => p.precisaDeRomaneio)
        .toList();

    final codigosAtivos = pendentes.map((p) => p.codPedido).toSet();
    await _localStore.limparConfirmados(codigosAtivos);

    return _localStore.aplicarOverrides(pendentes);
  }

  void _buscarPedidos() {
    setState(() {
      _futurePedidos = _buscarPedidosParaExibir();
    });
  }

  Future<void> _verificarNovoPedidos() async {
    try {
      final pedidos = await _buscarPedidosParaExibir();
      final codsAtuais = pedidos.map((p) => p.codPedido).toSet();

      if (_codPedidosConhecidos.isEmpty) {
        _codPedidosConhecidos = codsAtuais;
        return;
      }

      final chegaram = codsAtuais.difference(_codPedidosConhecidos);

      if (chegaram.isNotEmpty) {
        _codPedidosConhecidos = codsAtuais;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await NotificationService.tocarAlerta();
        });
        if (mounted) {
          setState(() => _todosPedidos = pedidos);
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar novos pedidos: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emptyFocus);
    });

    apiService = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5MjY1NDY5MjEsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6ImM0ODNnSDF1IiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.pEi6ia_w2Tbmi6AOWmFL1HDMn0ZrR9ouwg6t-dkb6IuOnN6k0P3c-WXUNKJiP5bSuUFfOSh_gG1L8Ean29L35w',
    );

    _buscarPedidos();
    _searchController.addListener(() => setState(() {}));

    _timer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _verificarNovoPedidos(),
    );
  }

  @override
  void dispose() {
    apiService.dispose();
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFE0E5EB),
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
                        const Text(
                          'Detalhes do Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          value: formatarData(
                            _pedidoSelecionado!.dataDigitacao,
                          ),
                          valueStyle: const TextStyle(
                            color: Color(0xFF0B1628),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        InfoColumn(
                          label: 'Checkout',
                          value: _pedidoSelecionado!.codEtapaExibicao == 4
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
                    title: InfoColumn(
                      label: 'CLIENTE',
                      value: _pedidoSelecionado!.nomeCliente,
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
                              const Text(
                                'Etapa',
                                style: TextStyle(
                                  color: Color(0xFF677383),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              EtapaColumn(
                                color: PedidoRecenteModel.corPorEtapa(
                                  _pedidoSelecionado!.codEtapaExibicao,
                                ),
                                codEtapa: _pedidoSelecionado!.codEtapaExibicao,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_pedidoSelecionado!.codEtapaExibicao == 4 ||
                      _pedidoSelecionado!.codEtapaExibicao == 3)
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
                                initialValue: _operadorSelecionado,
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
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: ElevatedButton(
                            onPressed: _operadorSelecionado == null
                                ? null
                                : () async {
                                    final codPedidoFinalizado =
                                        await Navigator.push<String>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RomaneioPage(
                                              codPedido:
                                                  _pedidoSelecionado!.codPedido,
                                              nameOperador:
                                                  _operadorSelecionado!,
                                            ),
                                          ),
                                        );

                                    if (codPedidoFinalizado != null &&
                                        mounted) {
                                      await _localStore.marcarFinalizado(
                                        _pedidoSelecionado!.codPedido,
                                      );
                                      setState(() {
                                        _pedidoSelecionado = _pedidoSelecionado!
                                            .copyWith(
                                              codEtapa: PedidoRecenteModel
                                                  .etapaRomaneioConcluidoLocal,
                                            );
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0043AC),
                              disabledBackgroundColor: const Color(0xFFB0B0B0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Acompanhar Pedido ${_pedidoSelecionado!.codPedido}',
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Selecione o operador para acompanhar o pedido.',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  else if (_pedidoSelecionado!.codEtapaExibicao ==
                      PedidoRecenteModel.etapaRomaneioConcluidoLocal)
                    ListTile(
                      title: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RomaneioPage(
                                codPedido: _pedidoSelecionado!.codPedido,
                                somenteLeitura: true,
                                // nameOperador: _operadorSelecionado,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0043AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label: Text(
                          'Ver Pedido ${_pedidoSelecionado!.codPedido}',
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                ],
              ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFD),
        title: const Text(
          'Consulta de Pedidos',
          style: TextStyle(
            color: Color(0xFF0043AC),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelecaoPerfilPage(),
                ),
              );
            },
            icon: const Icon(Icons.info_outline, color: Color(0xFF0043AC)),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cliente ou Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Buscar cliente ou N° do pedido...',
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
                      ],
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
                      'Pesquisar',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _buscarPedidos(),
                child: FutureBuilder<List<PedidoRecenteModel>>(
                  future: _futurePedidos,
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

                    _todosPedidos = snapshot.data ?? [];

                    if (_todosPedidos.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum pedido pendente de romaneio',
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
    );
  }
}
