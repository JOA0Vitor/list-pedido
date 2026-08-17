import 'package:flutter/material.dart';
import 'package:pedidosdp/page/api_configuracao/api_configuracao.dart';
import 'package:pedidosdp/page/relatorios/data/empresa_service.dart';
import 'package:pedidosdp/page/relatorios/data/metricas_resumo.dart';
import 'package:pedidosdp/page/relatorios/metricas_row.dart';
import 'package:pedidosdp/page/relatorios/resumo_operadores_card.dart';
import 'package:pedidosdp/page/relatorios/tendencia_pedidos_card.dart';
import 'package:pedidosdp/page/relatorios/widgets/filtro_periodo.dart';
import 'package:pedidosdp/page/relatorios/widgets/pedido_mock.dart';

enum Periodo {
  dias7(dias: 7, label: '7 dias'),
  dias15(dias: 15, label: '15 dias'),
  dias30(dias: 30, label: '30 dias'),
  dias90(dias: 90, label: '90 dias');

  const Periodo({required this.dias, required this.label});
  final int dias;
  final String label;
}

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<RelatoriosPage> {
  Periodo _periodoSelecionado = Periodo.dias30;
  final List<PedidoMock> _pedidosMock = gerarPedidosMockados();

  void _onPeriodoChanged(Periodo novo) {
    setState(() => _periodoSelecionado = novo);
  }

  @override
  Widget build(BuildContext context) {
    // final metricas = calcularMetricas(
    //   _pedidosMock,
    //   _periodoSelecionado,
    // );
    // final dadosTendencia = agruparPedidosPorDia(
    //   _pedidosMock,
    //   _periodoSelecionado,
    // );

    return ValueListenableBuilder<Empresa?>(
      valueListenable: EmpresaService.instance.empresaAtual,
      builder: (context, empresaAtual, _) {
        if (empresaAtual == null) {
          return const Center(child: Text('Nenhuma empresa selecionada'));
        }
        final empresaId = empresaAtual.id;
        final metricas = calcularMetricas(
          _pedidosMock,
          _periodoSelecionado,
          empresaId,
        );
        final dadosTendencia = agruparPedidosPorDia(
          _pedidosMock,
          _periodoSelecionado,
          empresaId,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Relatórios',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Empresa: ${empresaAtual.label}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Row(
                      children: [
                        FiltroPeriodo(
                          selecionado: _periodoSelecionado,
                          onChanged: _onPeriodoChanged,
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
                MetricasRow(metricas: metricas),

                SizedBox(height: 25),
                TendenciaPedidosCard(
                  dados: dadosTendencia,
                  periodo: _periodoSelecionado,
                ),

                SizedBox(height: 25),
                ResumoOperadoresCard(
                  pedidos: _pedidosMock,
                  periodo: _periodoSelecionado,
                  empresaId: empresaId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
