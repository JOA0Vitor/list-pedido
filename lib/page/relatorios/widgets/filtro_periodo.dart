import 'package:flutter/material.dart';
import 'package:pedidosdp/page/relatorios/relatorios_page.dart';

class FiltroPeriodo extends StatelessWidget {
  const FiltroPeriodo({super.key, 
    required this.selecionado,
    required this.onChanged,
  });

  final Periodo selecionado;
  final ValueChanged<Periodo> onChanged;

  Future<void> _abrirSeletor(BuildContext context) async {
    final escolhido = await showModalBottomSheet<Periodo>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PeriodoBottomSheet(selecionado: selecionado),
    );

    if (escolhido != null) {
      onChanged(escolhido);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _abrirSeletor(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      icon: const Icon(
        Icons.calendar_month_outlined,
        color: Colors.black,
        size: 18,
      ),
      label: Text(
        'Últimos ${selecionado.dias} dias',
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}

class _PeriodoBottomSheet extends StatelessWidget {
  const _PeriodoBottomSheet({required this.selecionado});

  final Periodo selecionado;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Selecionar período',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          for (final periodo in Periodo.values)
            ListTile(
              title: Text(
                'Últimos ${periodo.dias} dias',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: periodo == selecionado
                  ? const Icon(Icons.check, color: Color(0xFF0043AC))
                  : null,
              onTap: () => Navigator.of(context).pop(periodo),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}