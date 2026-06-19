import 'package:flutter/material.dart';

class EtapaColumn extends StatelessWidget {
  final Color color;
  final int codEtapa;

  const EtapaColumn({super.key, required this.color, required this.codEtapa});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          codEtapa == 3
              ? 'SEPARAÇÃO & ROMANEIO'
              : codEtapa == 4
              ? 'BIPAGEM & CONFERÊNCIA'
              : codEtapa == 5
              ? 'FATURAMENTO'
              : codEtapa == 9
              ? 'CARREGAMENTO CONCLUÍDO'
              : 'ERRO ;-;',
          // etapa.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF0B1628),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 6,
          color: codEtapa == 3
              ? Color(0xFF607d8b)
              : codEtapa == 4
              ? Color(0xFFFE8D00)
              : codEtapa == 5
              ? Color(0xFF4e2da2)
              : codEtapa == 9
              ? Color(0xFF3d7d24)
              : Color(0xFFFE8D00),
        ),
      ],
    );
  }
}
