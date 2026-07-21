// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pedidosdp/models/romaneio_model.dart';
import 'package:pedidosdp/page/corte/corte_industrial.dart';

import '../../service/api_service.dart';

class RomaneioPage extends StatefulWidget {
  final String codPedido;

  const RomaneioPage({super.key, required this.codPedido});

  @override
  State<RomaneioPage> createState() => _RomaneioPageState();
}

class _RomaneioPageState extends State<RomaneioPage> {
  late final ApiService _api;
  late Future<PaginatedResponseRomaneio<RomaneioModel>> _futureRomaneio;
  final Map<int, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    _api = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5MjY1NDY5MjEsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6ImM0ODNnSDF1IiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.pEi6ia_w2Tbmi6AOWmFL1HDMn0ZrR9ouwg6t-dkb6IuOnN6k0P3c-WXUNKJiP5bSuUFfOSh_gG1L8Ean29L35w',
    );
    _futureRomaneio = _api.getRomaneio(
      2,
      widget.codPedido,
      'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5MjY1NDY5MjEsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6ImM0ODNnSDF1IiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.pEi6ia_w2Tbmi6AOWmFL1HDMn0ZrR9ouwg6t-dkb6IuOnN6k0P3c-WXUNKJiP5bSuUFfOSh_gG1L8Ean29L35w',
    );
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  static const Color _borderColor = Color(0xFFDEE2E6);
  static const double _borderWidth = 1.0;

 
  static const Color _evenColor = Colors.white;

  static const Color _oddColor = Color(0xFFFAFBFC);
  final Map<int, TipoGola> _tipoGolaPorItem = {};
  final Map<int, TextEditingController> _controllersQtdCamisas = {};
  final Map<int, TextEditingController> _controllersQtdGramas = {};

  String _formatarTotal(int index) {
    final tipoGola = _tipoGolaPorItem[index] ?? TipoGola.gola;
    final total = _calcularTotal(index);

    if (tipoGola == TipoGola.gola) {
      return '${total.toStringAsFixed(0)}KIT';
    }
    return '${_formatarPesoComPonto(total)}KG';
  }

  TextEditingController _controllerCamisas(int index) {
    return _controllersQtdCamisas.putIfAbsent(index, () {
      final controller = TextEditingController();
      controller.addListener(() => setState(() {}));
      return controller;
    });
  }

  TextEditingController _controllerGramas(int index) {
    return _controllersQtdGramas.putIfAbsent(index, () {
      final controller = TextEditingController();
      controller.addListener(() => setState(() {}));
      return controller;
    });
  }

  double _calcularTotal(int index) {
    final qtdCamisas = double.tryParse(_controllerCamisas(index).text) ?? 0;

    if ((_tipoGolaPorItem[index] ?? TipoGola.gola) == TipoGola.gola) {
      return qtdCamisas;
    }

    final qtdGramas = double.tryParse(_controllerGramas(index).text) ?? 0;
    return qtdCamisas * qtdGramas;
  }

  String _formatarPesoComPonto(double valor) {
    final inteiro = valor.round();
    final str = inteiro.toString();
    final digitos = str.length;

    if (digitos <= 3) return str;

    final posicaoPonto = digitos - 3;
    return '${str.substring(0, posicaoPonto)}.${str.substring(posicaoPonto)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Romaneio',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text('Pedido ${widget.codPedido}'),
            const Spacer(),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final vaiTerAcessorio = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar finalização'),
                  content: const Text(
                    'Vai ter acessório?',
                    style: TextStyle(fontSize: 21),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAC0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Não',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0043AC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Sim',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ],
                ),
              );

              if (vaiTerAcessorio == null) return;

              try {
                List<Map<String, dynamic>>? itensParaCorte;

                if (vaiTerAcessorio) {
                  final resposta = await _futureRomaneio;
                  final itens = resposta.itens;

                  itensParaCorte = itens.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final tipoGola = _tipoGolaPorItem[index] ?? TipoGola.gola;

                    return {
                      'tipo': tipoGola == TipoGola.gola ? 'Gola' : 'Rib',
                      'cor': item.codCor,
                      'qtd': item.qtdPedida,
                      'unidade': _formatarTotal(index) == 'KIT' ? 'KIT' : 'KG',
                    };
                  }).toList();
                }

                await _api.finalizarPedidoT(
                  widget.codPedido,
                  itens: itensParaCorte,
                );
                if (!mounted) return;
                Navigator.pop(context, widget.codPedido);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao finalizar pedido: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0043AC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Finalizar Pedido',
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
      body: FutureBuilder<PaginatedResponseRomaneio<RomaneioModel>>(
        future: _futureRomaneio,

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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final itens = snapshot.data?.itens ?? [];

          if (itens.isEmpty) {
            return const Center(child: Text('Nenhum item encontrado.'));
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: _borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFFE9ECEF),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        _headerCell('Código', flex: 2, align: TextAlign.left),
                        _headerCell(
                          'Descrição',
                          flex: 6,
                          align: TextAlign.left,
                        ),
                        _headerCell(
                          'Local WMS',
                          flex: 4,
                          align: TextAlign.center,
                        ),
                        _headerCell('Peças', flex: 2, align: TextAlign.center),
                        _headerCell(
                          'Quantidade',
                          flex: 3,
                          align: TextAlign.right,
                        ),
                        const SizedBox(width: 28),
                      ],
                    ),
                  ),
                  Container(height: 2, color: Color(0xFFDEE2E6)),
                  Expanded(
                    child: ListView.separated(
                      itemCount: itens.length,
                      separatorBuilder: (_, _) =>
                          Container(height: 1, color: _borderColor),
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        // final isEven = index % 2 == 0;
                        final quantidadeDividida = item.qtdPedida / 15;

                        final isChecked = _checkedItems[index] ?? false;

                        final backgroundColor = isChecked
                            ? const Color.fromARGB(255, 164, 255, 151)
                            : (index % 2 == 0 ? _evenColor : _oddColor);

                        return Container(
                          color: backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              _dataCellCor(
                                '${item.codProdutoPai}.',
                                '${item.codCor}',
                                flex: 2,
                                isCode: true,
                              ),
                              _verticalDividerRow(),
                              _dataCell(item.descProdutoGen, flex: 6),
                              _verticalDividerRow(),
                              _verticalDividerRow(),
                              _dataCell(
                                item.localNatureza ?? '—',
                                flex: 3,
                                center: true,
                                bold: true,
                              ),
                              _verticalDividerRow(),
                              _dataCellPecas(
                                quantidadeDividida.toStringAsFixed(0),
                                flex: 1,
                                center: true,
                                // muted: item.localNatureza == null,
                              ),
                              _verticalDividerRow(),
                              _dataCell(
                                '${item.qtdPedida.toStringAsFixed(1)}KG',
                                flex: 2,
                                right: true,
                                bold: true,
                              ),
                              _verticalDividerRow(),
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _checkedItems[index] = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => HomePage()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color(0xFF0043AC),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Finalizar Pedido',
                  //     style: TextStyle(color: Color(0xFFFFFFFF)),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerCell(
    String text, {
    required int flex,
    required TextAlign align,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          textAlign: align,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF495057),
          ),
        ),
      ),
    );
  }

  Widget _dataCell(
    String text, {
    required int flex,
    bool center = false,
    bool right = false,
    bool isCode = false,
    bool bold = false,
    bool muted = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          textAlign: center
              ? TextAlign.center
              : right
              ? TextAlign.right
              : TextAlign.left,
          style: TextStyle(
            fontSize: isCode ? 12 : 13,
            fontFamily: isCode ? 'monospace' : null,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: muted ? const Color(0xFFADB5BD) : const Color(0xFF212529),
          ),
        ),
      ),
    );
  }

  Widget _dataCellPecas(String text, {required int flex, bool center = false}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0043AC),
          ),
        ),
      ),
    );
  }

  Widget _dataCellCor(
    String textRef,
    String textCor, {
    required int flex,
    bool isCode = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textRef,
              style: TextStyle(
                fontSize: isCode ? 12 : 13,
                fontFamily: isCode ? 'monospace' : null,
                color: const Color(0xFF212529),
              ),
            ),
            Text(
              textCor,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDividerRow() {
    return Container(width: _borderWidth, height: 16, color: _borderColor);
  }
}
