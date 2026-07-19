import 'package:flutter/material.dart';
import 'package:pedidosdp/models/romaneio_model.dart';
import 'package:pedidosdp/page/home_page.dart';
import 'package:pedidosdp/service/whatsapp_service.dart';

import '../service/api_service.dart';

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

  static const Color _selectedColor = Color(
    0xFFE3F2FD,
  ); // Azul claro quando selecionado
  static const Color _evenColor = Colors.white;
  static const Color _oddColor = Color(0xFFFAFBFC);

  // Future<void> _finalizarPedido() async {
  //   setState(() => _finalizando = true);
  //   try {
  //     await _api.finalizarPedido(widget.codPedido);
  //     if (!mounted) return;
  //     // Devolve o codPedido pra Home, que troca a etapa localmente
  //     // (sem precisar bater na API de novo pra saber o que já sabemos).
  //     Navigator.pop(context, widget.codPedido);
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Erro ao finalizar pedido: $e')));
  //   } finally {
  //     if (mounted) setState(() => _finalizando = false);
  //   }
  // }

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
          // ElevatedButton(
          //   onPressed: () async {
          //     print('Finalizando pedido... ${widget.codPedido}');
          //     Navigator.pop(context);
          //     await _api.finalizarPedido(widget.codPedido);
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
          ElevatedButton(
            onPressed: () async {
              //Colocar um alertDialog perguntando se vai ter asssessorio,
              // se sim, vai mandar os dados para o backend do app corte industrial, e depois fechar a tela
              //se não, vai finalizar o pedido e fechar a tela
              try {
                await _api.finalizarPedido(widget.codPedido);
                if (!mounted) return;
                Navigator.pop(
                  context,
                  widget.codPedido,
                ); // <- devolve o codPedido
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
          // if (snapshot.hasError) {
          //   return Center(child: Text('Erro ROMANEIO: ${snapshot.error}'));
          // }
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
                      separatorBuilder: (_, __) =>
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
