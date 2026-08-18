import 'package:flutter/material.dart';
import 'package:pedidosdp/page/adm/relatorios/data/operador_resumo.dart';
import 'package:pedidosdp/page/adm/relatorios/relatorios_page.dart';
import 'package:pedidosdp/page/adm/relatorios/widgets/header_cell.dart';
import 'package:pedidosdp/page/adm/relatorios/widgets/operador_row.dart';
import 'package:pedidosdp/page/adm/relatorios/widgets/pedido_mock.dart';

class ResumoOperadoresCard extends StatefulWidget {
  const ResumoOperadoresCard({
    super.key,
    required this.pedidos,
    required this.periodo,
    required this.empresaId,
  });

  final List<PedidoMock> pedidos;
  final Periodo periodo;
  final int empresaId;

  @override
  State<ResumoOperadoresCard> createState() => _ResumoOperadoresCardState();
}

class _ResumoOperadoresCardState extends State<ResumoOperadoresCard> {
  final _filtroController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resumoCompleto = calcularResumoOperadores(
      widget.pedidos,
      widget.periodo,
      widget.empresaId,
    );
    final resumoFiltrado = _filtro.isEmpty
        ? resumoCompleto
        : resumoCompleto
              .where(
                (o) => o.nome.toLowerCase().contains(_filtro.toLowerCase()),
              )
              .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 163, 165, 167),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text(
                  'Resumo por Operador',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: TextFormField(
                    controller: _filtroController,
                    onChanged: (valor) => setState(() => _filtro = valor),
                    decoration: InputDecoration(
                      hintText: 'Filtrar...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _filtro.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _filtroController.clear();
                                setState(() => _filtro = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFE9ECEF),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              children: [
                HeaderCell('Nome', flex: 2, align: TextAlign.left),
                HeaderCell(
                  'Pedidos Fidelizados',
                  flex: 6,
                  align: TextAlign.left,
                ),
                HeaderCell('Eficiência', flex: 2, align: TextAlign.center),
              ],
            ),
          ),
          if (resumoFiltrado.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Nenhum operador encontrado',
                style: TextStyle(color: Color(0xFFADB5BD)),
              ),
            )
          else
            for (var i = 0; i < resumoFiltrado.length; i++)
              OperadorRow(operador: resumoFiltrado[i], zebra: i.isOdd),
        ],
      ),
    );
  }
}
