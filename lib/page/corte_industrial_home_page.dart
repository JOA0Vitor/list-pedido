import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/page/corte_industrial.dart';

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

  OutlineInputBorder get _fieldBorder =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E5EB),

      appBar: AppBar(
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
            onPressed: () {},
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
            Text('Lista de Pedidos'),
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
