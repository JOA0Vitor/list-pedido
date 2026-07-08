import 'package:flutter/material.dart';
import 'package:pedidosdp/page/home_page.dart';

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
    _api = ApiService(
      apiToken:
          'eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhcGkiLCJhdWQiOiJhcGkiLCJleHAiOjE5Mzc2MTQzMjgsInN1YiI6ImpvYW8udml0b3IiLCJjc3dUb2tlbiI6Ik1WbkpKaGdGIiwiZGJOYW1lU3BhY2UiOiJjb25zaXN0ZW0ifQ.9s0aPo2hlN2xIVdc7pnazlUfU8t3m6C_864XHkv2XNQhU6lpE7vYCSyWb9Vf7lHvUTTEPsSdqwm5hBadArJYFQ',
    );
    _futureRomaneio = _api.getRomaneioTextil();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  static const Color _borderColor = Color(0xFFDEE2E6);
  static const double _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Romaneio'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
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
      body: FutureBuilder<dynamic>(
        future: _futureRomaneio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // if (snapshot.hasError) {
          //   return Center(child: Text('Erro ROMANEIO: ${snapshot.error}'));
          // }

          final data = snapshot.data;
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
                          flex: 5,
                          align: TextAlign.center,
                        ),
                        _headerCell('Peças', flex: 2, align: TextAlign.center),
                        _headerCell(
                          'Quantidade',
                          flex: 2,
                          align: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(height: 2, color: Color(0xFFDEE2E6)),
                  // Rows
                  Expanded(
                    child: ListView.separated(
                      itemCount: 15,
                      separatorBuilder: (_, __) =>
                          Container(height: 1, color: _borderColor),
                      itemBuilder: (context, index) {
                        // final item = itens[index];
                        final isEven = index % 2 == 0;
                        return Container(
                          color: isEven
                              ? Colors.white
                              : const Color(0xFFFAFBFC),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              _dataCell(
                                '624619.0001417',
                                flex: 2,
                                isCode: true,
                              ),
                              _verticalDividerRow(),
                              _dataCell(
                                'MALHA MAXI d, c/ acess. ecv enigmatic mr es 2.2fh',
                                flex: 6,
                              ),
                              _verticalDividerRow(),
                              _verticalDividerRow(),
                              _dataCell(
                                '988-EXPOS/F.51.1/F.47.1',
                                flex: 3,
                                center: true,
                                bold: true,
                              ),
                              _verticalDividerRow(),
                              _dataCell(
                                '10' ?? '—',
                                flex: 2,
                                center: true,
                                muted: 'item.localNatureza' == null,
                              ),
                              _verticalDividerRow(),
                              _dataCell(
                                '150.000',
                                flex: 2,
                                right: true,
                                bold: true,
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
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF495057),
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

  Widget _verticalDividerRow() {
    return Container(width: _borderWidth, height: 16, color: _borderColor);
  }
}
