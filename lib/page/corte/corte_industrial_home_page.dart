import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/page/corte/corte_industrial.dart';
import 'package:pedidosdp/page/corte/list_pedidos_corte.dart';
import 'package:pedidosdp/page/selecao_perfil_page.dart';
import 'package:pedidosdp/service/api_service.dart';

class CorteIndustrialHomePage extends StatefulWidget {
  const CorteIndustrialHomePage({super.key});

  @override
  State<CorteIndustrialHomePage> createState() =>
      _CorteIndustrialHomePageState();
}

class _CorteIndustrialHomePageState extends State<CorteIndustrialHomePage> {
  final _searchController = TextEditingController();
  final _dataInicialController = TextEditingController();
  final _dataFinalController = TextEditingController();
  // final style = StyleGlobal();
  final labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  Timer? _timer;
  late Future<List<dynamic>> _futureDadosCorte;
  late final ApiService _api;
  List<CorteModel> _todosPedidos = [];
  static List<CorteModel> corteFilaMock = [
    CorteModel(
      codPedido: '4655',
      codProdutoPai: '624616',
      codCor: '2306',
      corHex: '#E3F9A6',
      peso: 15,
      status: 1,
      dataEmissao: '2026-07-19',
    ),
    CorteModel(
      codPedido: '4481',
      codProdutoPai: '624619',
      codCor: '2201',
      corHex: '#FF7F50',
      peso: 12,
      status: 4,
      dataEmissao: '2026-07-18',
    ),
  ];

  OutlineInputBorder get _fieldBorder =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  List<CorteModel> get _cortesFiltrados {
    final termo = _searchController.text.toLowerCase();
    if (termo.isEmpty) return _todosPedidos;
    return _todosPedidos.where((p) {
      // final nome = (_nomesClientes[p.codCliente] ?? '').toLowerCase();
      return p.codPedido.toLowerCase().contains(
        termo,
      ) /* || nome.contains(termo) */;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _api = ApiService(
      apiToken: 'SEU_TOKEN_AQUI',
    ); // mesmo token usado nas outras telas
    _buscarPedidos();
  }

  Future<PaginatedResponseCorte<CorteModel>> getFilaCorteMock() async {
    // Simula o delay de uma chamada de rede real, pra você ver o loading também.
    await Future.delayed(const Duration(milliseconds: 500));

    final itensFalsos = [
      CorteModel(
        codPedido: '4481',
        status: 1, // pendente
        dataEmissao: '2026-07-15',
      ),
      CorteModel(
        codPedido: '4466',
        status: 1, // pendente
        dataEmissao: '2026-07-14',
      ),
      CorteModel(
        codPedido: '4436',
        status: 4, // já concluído
        dataEmissao: '2026-07-13',
      ),
    ];

    return PaginatedResponseCorte(codPedido: '', itens: itensFalsos);
  }

  void _buscarPedidos() {
    setState(() {
      // _futureDadosCorte = Future.wait([_api.getFilaCorte()]);
      _futureDadosCorte = Future.wait([getFilaCorteMock()]);
    });
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'Consulta de Pedidos',
          style: TextStyle(
            fontSize: 25,
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
            icon: const Icon(
              Icons.info_outline,
              color: Color(0xFF0043AC),
              size: 30,
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildFiltroPedidos(),
            const SizedBox(height: 30),
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
                  future: _futureDadosCorte,
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
                            // ElevatedButton(
                            //   onPressed: _buscarPedidos,
                            //   child: const Text('Tentar novamente'),
                            // ),
                          ],
                        ),
                      );
                    }

                    final pedidosResponse =
                        snapshot.data![0] as PaginatedResponseCorte<CorteModel>;

                    _todosPedidos = pedidosResponse.itens;

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
                      child: PedidosScreenCorte(
                        pedidos: _cortesFiltrados,
                        status: _todosPedidos.length,
                        // nomesClientes: _nomesClientes,
                        onPedidoTap: (pedido) {
                          // setState(() {
                          //   _pedidoSelecionado = pedido;
                          //   _operadorSelecionado = null;
                          // });
                          if (pedido.status == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CorteIndustrial(
                                  codPedido: pedido.codPedido,
                                ),
                              ),
                            );
                          }
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

  Widget _buildLabeledField({required String label, required Widget field}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        field,
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () => _selecionarData(controller),
        ),
        border: _fieldBorder,
      ),
    );
  }

  Future<void> _selecionarData(TextEditingController controller) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      controller.text =
          "${dataSelecionada.day.toString().padLeft(2, '0')}/"
          "${dataSelecionada.month.toString().padLeft(2, '0')}/"
          "${dataSelecionada.year}";
    }
  }

  Widget _buildFiltroPedidos() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: _buildLabeledField(
              label: 'Pesquisar pedidos',
              field: TextFormField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'N° do pedido...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: _fieldBorder,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: _buildLabeledField(
              label: 'Data Inicial',
              field: _buildDateField(
                controller: _dataInicialController,
                hint: 'Data inicial',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: _buildLabeledField(
              label: 'Data Final',
              field: _buildDateField(
                controller: _dataFinalController,
                hint: 'Data final',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: ElevatedButton(
                onPressed: () {
                  // NotificationService.tocarAlerta();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CorteIndustrial(codPedido: '4481'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 55),
                  backgroundColor: const Color(0xFF0043AC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Filtrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
