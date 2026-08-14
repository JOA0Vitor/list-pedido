import 'package:flutter/material.dart';
import 'package:pedidosdp/models/corte_model.dart';

class AgendarPedidoDialog extends StatefulWidget {
  const AgendarPedidoDialog({super.key, required this.pedido});

  final CorteModel pedido;

  @override
  State<AgendarPedidoDialog> createState() => _AgendarPedidoDialogState();
}

class _AgendarPedidoDialogState extends State<AgendarPedidoDialog> {
  static const _primaryColor = Color(0xFF0043AC);
  static const _lightGray = Color(0xFFF0F2F5);

  Turno _turnoSelecionado = Turno.manha;
  DateTime? _dataSelecionada;
  late final TextEditingController _dataController;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController();
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 365)),
    );
    if (escolhida == null) return;

    setState(() {
      _dataSelecionada = escolhida;
      _dataController.text =
          '${escolhida.day.toString().padLeft(2, '0')}/'
          '${escolhida.month.toString().padLeft(2, '0')}/${escolhida.year}';
    });
  }

  void _confirmar() {
    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data de agendamento')),
      );
      return;
    }
    Navigator.of(
      context,
    ).pop(AgendamentoResult(data: _dataSelecionada!, turno: _turnoSelecionado));
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Dialog(
      shape: shape,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380), // <- largura fixa

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER — cinza claro
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: _lightGray,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agendar Pedido',
                        style: TextStyle(
                          fontSize: 20,
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selecione a data e o turno para o corte',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF677383),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTEÚDO — branco
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        const Text(
                          'Data de Agendamento',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF677383),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _dataController,
                          readOnly: true,
                          onTap: _selecionarData,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Selecione uma data',
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Turno',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF677383),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _TurnoButton(
                              icon: Icons.wb_sunny_outlined,
                              label: 'Manhã',
                              isSelected: _turnoSelecionado == Turno.manha,
                              onTap: () => setState(
                                () => _turnoSelecionado = Turno.manha,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _TurnoButton(
                              icon: Icons.shower_rounded,
                              label: 'Tarde',
                              isSelected: _turnoSelecionado == Turno.tarde,
                              onTap: () => setState(
                                () => _turnoSelecionado = Turno.tarde,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // FOOTER — cinza claro
                Container(
                  width: double.infinity,
                  color: _lightGray,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFF677383)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _confirmar,
                        child: const Text(
                          'Confirmar \nAgendamento',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Turno { manha, tarde }

class _TurnoButton extends StatelessWidget {
  const _TurnoButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const _primaryColor = Color(0xFF0043AC);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _primaryColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _primaryColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgendamentoResult {
  const AgendamentoResult({required this.data, required this.turno});

  final DateTime data;
  final Turno turno;
}
