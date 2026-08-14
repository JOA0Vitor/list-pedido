import 'package:flutter/material.dart';
import 'package:pedidosdp/page/relatorios/widgets/metric_card.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<RelatoriosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relatórios',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Visão geral das métricas operacionais e do desempenho dos operadores',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gráficos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black,
                          size: 18,
                        ),
                        label: const Text(
                          'Ultimos 30 dias',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0043AC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Exportar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Total de pedidos',
                      value: '14,285',
                      icon: Icons.show_chart_rounded,
                      color: const Color(0xD528A028),
                      message: '+12.5% vs ultimo mês',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      label: 'Média por operador',
                      value: '420',
                      icon: Icons.remove,
                      color: Colors.grey,
                      message: 'Compatível com a média',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                height: 230,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 163, 165, 167),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tendência de Pedidos (30 Dias)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                  ],
                ),
              ),
              SizedBox(height: 25),
              // Container(
              //   color: const Color(0xFFE9ECEF),
              //   padding: const EdgeInsets.symmetric(vertical: 12),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Resumo por Operador',
              //         style: const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const Spacer(),
              //       TextFormField()
              //     ],
              //   ),
              // ),
              Container(
                color: const Color(0xFFE9ECEF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    _headerCell('Nome', flex: 2, align: TextAlign.left),
                    _headerCell(
                      'Pedidos Fidelizados',
                      flex: 6,
                      align: TextAlign.left,
                    ),
                    _headerCell('Eficiência', flex: 2, align: TextAlign.center),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFFAFBFC),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    _verticalDividerRow(),
                    _dataCell('Gledson', flex: 2),

                    _verticalDividerRow(),
                    _dataCell('352', flex: 6),
                    _verticalDividerRow(),
                    _dataCell('95.4%', flex: 2, center: true, bold: true),
                    _verticalDividerRow(),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _verticalDividerRow() {
    return Container(width: 1.0, height: 16, color: Color(0xFFDEE2E6));
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
            fontSize: isCode ? 11 : 12,
            fontFamily: isCode ? 'monospace' : null,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: muted ? const Color(0xFFADB5BD) : const Color(0xFF212529),
          ),
        ),
      ),
    );
  }
}
