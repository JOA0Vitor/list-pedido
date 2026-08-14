import 'package:flutter/material.dart';
import 'package:pedidosdp/page/relatorios/relatorios_page.dart';
import 'package:pedidosdp/page/selecao_perfil_page.dart';
import 'package:pedidosdp/widgets/drawer_item.dart';
import 'package:pedidosdp/widgets/period_button.dart';
import 'package:pedidosdp/widgets/summary_stat.dart';
// import 'package:pedidosdp/models/pedido_recente_model.dart';

class AdmPage extends StatefulWidget {
  // final List<PedidoRecenteModel> pedidos;
  const AdmPage({super.key /*  required this.pedidos */});

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
  String _selectedPeriod = 'Dia';

  static const _periods = ['Dia', 'Semana', 'Mês'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Painel de Controle',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Deposito de Malhas',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                'Admin Console',
                style: TextStyle(fontSize: 18),
              ),
            ),
            DrawerItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              onTap: () => Navigator.of(context).pop(),
            ),
            DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              onTap: () => Navigator.of(context).pop(),
            ),
            DrawerItem(
              icon: Icons.person_2_outlined,
              label: 'Operadores',
              onTap: () => Navigator.of(context).pop(),
            ),
            DrawerItem(
              icon: Icons.insert_chart_outlined_rounded,
              label: 'Relatórios',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RelatoriosPage(),
                ),
              ),
            ),
            const Spacer(),
            DrawerItem(
              icon: Icons.logout,
              label: 'Sair',
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SelecaoPerfilPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Visão geral do desempenho industrial e configurações de infraestrutura',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard de Desempenho',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 222, 227, 231),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: _periods.map((period) {
                        final isSelected = period == _selectedPeriod;
                        return PeriodButton(
                          label: period,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedPeriod = period),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 242, 245),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 163, 165, 167),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 210,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF000666),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 163, 165, 167),
                    width: 1,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo Geral',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    SummaryStat(
                      label: 'total finalizado',
                      value: '1284',
                      trend: '+12% vs mês anterior',
                    ),
                    Divider(color: Colors.grey, thickness: 0.8, height: 15.0),
                    SummaryStat(label: 'Tempo Médio', value: '14m 22s'),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gestão de Operadores',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0043AC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    label: const Text(
                      'Adicionar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Container(
                color: const Color(0xFFE9ECEF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    _headerCell('Operador', flex: 2, align: TextAlign.left),
                    _headerCell('Outro', flex: 6, align: TextAlign.left),
                    _headerCell('Ações', flex: 2, align: TextAlign.center),
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
                    _dataCell('10', flex: 6),
                    _verticalDividerRow(),
                    _dataCell(
                      '...',
                      flex: 2,
                      center: true,
                      bold: true,
                    ),
                    _verticalDividerRow(),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
      // body: ListView.builder(
      //   itemCount: widget.pedidos.length,
      //   itemBuilder: (context, index) {
      //     final pedido = widget.pedidos[index];
      //     return ListTile(
      //       title: Text(pedido.nomeCliente),
      //       subtitle: Text(pedido.codPedido),
      //     );
      //   },
      // ),
    );
  }
}

Widget _headerCell(String text, {required int flex, required TextAlign align}) {
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
