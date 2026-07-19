import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/widgets/item_corte_resumo.dart';
import 'package:printing/printing.dart';

enum TipoGola { gola, rib }

class CorteIndustrial extends StatefulWidget {
  final String codPedido;

  const CorteIndustrial({super.key, required this.codPedido});

  @override
  State<CorteIndustrial> createState() => _CorteIndustrialState();
}

class _CorteIndustrialState extends State<CorteIndustrial> {
  // late final ApiService _api;
  //9616
  late Future<PaginatedResponseCorte<CorteModel>> _futureCorte;

  final Map<int, TipoGola> _tipoGolaPorItem = {};
  final Map<int, TextEditingController> _controllersQtdCamisas = {};
  final Map<int, TextEditingController> _controllersQtdGramas = {};
  bool _finalizando = false;
  final corterResumoPdf = CorteResumoPdf();

  static const Color _borderColor = Color(0xFFDEE2E6);
  static const double _borderWidth = 1.0;
  static const Color _evenColor = Colors.white;
  static const Color _oddColor = Color(0xFFFAFBFC);

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

  final List<CorteModel> _itens = [
    CorteModel(
      codPedido: '4481',
      codProdutoPai: '612251',
      codCor: '8221',
      corHex: '#0043AC',
      peso: 15,
    ),
    CorteModel(
      codPedido: '4482',
      codProdutoPai: '612251',
      codCor: '803',
      corHex: '#FF0000',
      peso: 28,
    ),
    CorteModel(
      codPedido: '4483',
      codProdutoPai: '612251',
      codCor: '6500',
      corHex: '#000000',
      peso: 45,
    ),
  ];

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

  String _formatarTotal(int index) {
    final tipoGola = _tipoGolaPorItem[index] ?? TipoGola.gola;
    final total = _calcularTotal(index);

    if (tipoGola == TipoGola.gola) {
      return '${total.toStringAsFixed(0)}KIT';
    }
    return '${_formatarPesoComPonto(total)}KG';
  }

  List<ItemCorteResumo> _montarResumoParaPdf() {
    final resumo = <ItemCorteResumo>[];

    for (var index = 0; index < _itens.length; index++) {
      final item = _itens[index];
      final tipoGola = _tipoGolaPorItem[index] ?? TipoGola.gola;

      resumo.add(
        ItemCorteResumo(
          tipo: tipoGola == TipoGola.gola ? 'Gola' : 'Rib',
          codigo: item.codProdutoPai ?? '-',
          cor: item.codCor ?? '-',
          pesoFormatado: _formatarTotal(index),
        ),
      );
    }

    return resumo;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    for (final c in _controllersQtdCamisas.values) {
      c.dispose();
    }
    for (final c in _controllersQtdGramas.values) {
      c.dispose();
    }
    // _api.dispose();
    super.dispose();
  }

  static const double _alturaBotao = 44;
  static const double _espacamentoBotao = 16;
  static const double _folgaEntreListaEBotao = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Corte Industrial',
              style: TextStyle(fontSize: 20, color: Color(0xFF0043AC)),
            ),
            Text(
              'Pedido ${widget.codPedido}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline, color: Color(0xFF0043AC)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
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
                        _headerCell('Tipo', flex: 2, align: TextAlign.center),
                        _headerCell('Ref', flex: 2, align: TextAlign.right),
                        _headerCell('Cor', flex: 2, align: TextAlign.right),
                        _headerCell('Peso', flex: 2, align: TextAlign.right),
                        _headerCell(
                          'Qtd.camisas',
                          flex: 2,
                          align: TextAlign.right,
                        ),
                        _headerCell('Gramas', flex: 2, align: TextAlign.right),
                        _headerCell('Total', flex: 3, align: TextAlign.center),
                      ],
                    ),
                  ),
                  Container(height: 2, color: Color(0xFFDEE2E6)),
                  Expanded(
                    child: _itens.isEmpty
                        ? const Center(child: Text('Nenhum item encontrado'))
                        : ListView.separated(
                            itemCount: _itens.length,
                            padding: const EdgeInsets.only(
                              bottom:
                                  _alturaBotao +
                                  _espacamentoBotao +
                                  _folgaEntreListaEBotao,
                            ),
                            separatorBuilder: (_, __) =>
                                Container(height: 1, color: _borderColor),
                            itemBuilder: (context, index) {
                              final item = _itens[index];
                              final tipoGolaAtual =
                                  _tipoGolaPorItem[index] ?? TipoGola.gola;
                              final backgroundColor = (index % 2 == 0
                                  ? _evenColor
                                  : _oddColor);

                              return Container(
                                color: backgroundColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9ECEF),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: _borderColor,
                                            width: _borderWidth,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            _botaoToggle(
                                              'Gola',
                                              tipoGolaAtual == TipoGola.gola,
                                              () {
                                                setState(
                                                  () =>
                                                      _tipoGolaPorItem[index] =
                                                          TipoGola.gola,
                                                );
                                              },
                                            ),
                                            _botaoToggle(
                                              'Rib',
                                              tipoGolaAtual == TipoGola.rib,
                                              () {
                                                setState(
                                                  () =>
                                                      _tipoGolaPorItem[index] =
                                                          TipoGola.rib,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _verticalDividerRow(),
                                    _dataCellCor(
                                      '${item.codProdutoPai ?? '-'}.',
                                      item.codCor ?? '-',
                                      flex: 1,
                                      isCode: true,
                                    ),
                                    _verticalDividerRow(),
                                    _dataCell(
                                      item.corHex ?? '-',
                                      flex: 1,
                                      center: true,
                                      bold: true,
                                    ),
                                    _verticalDividerRow(),
                                    _dataCellPecas(
                                      '${item.peso ?? 0}KG',
                                      flex: 1,
                                      center: true,
                                    ),
                                    _verticalDividerRow(),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        keyboardType: TextInputType.number,
                                        controller: _controllerCamisas(index),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                          hintText: 'Ex: 120',
                                        ),
                                      ),
                                    ),
                                    _verticalDividerRow(),
                                    tipoGolaAtual == TipoGola.gola
                                        ? const Expanded(
                                            flex: 1,
                                            child: Icon(Icons.block),
                                          )
                                        : Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controller: _controllerGramas(
                                                index,
                                              ),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                hintText: 'Ex: 10x',
                                              ),
                                            ),
                                          ),
                                    _verticalDividerRow(),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 13,
                                        ),
                                        child: Text(
                                          _formatarTotal(index),
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 56),
          Positioned(
            left: 40,
            right: 40,
            bottom: 6,
            child: ElevatedButton(
              onPressed: () async {
                setState(() => _finalizando = true);
                try {
                  final itens =
                      _montarResumoParaPdf(); // você monta a partir do seu model/controllers
                  final pdfBytes = await corterResumoPdf.gerarPdfPedido(
                    codPedido: widget.codPedido,
                    itens: itens,
                  );

                  // Opção A: deixar o usuário visualizar/compartilhar/imprimir
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename: 'pedido_${widget.codPedido}.pdf',
                  );

                  // Opção B: enviar direto pra sua futura API
                  // final response = await http.post(
                  //   Uri.parse('https://sua-api.com/pedidos/${widget.codPedido}/finalizar'),
                  //   headers: {'Content-Type': 'application/pdf'},
                  //   body: pdfBytes,
                  // );
                } finally {
                  setState(() => _finalizando = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0043AC),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _finalizando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Finalizar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoToggle(String label, bool selecionado, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
        backgroundColor: selecionado ? Colors.white : const Color(0xFFE9ECEF),
        side: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: selecionado
              ? const Color(0xFF0043AC)
              : const Color(0xFF77767D),
        ),
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
