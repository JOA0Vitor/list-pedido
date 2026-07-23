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
          codEtapa == 3 ? 'A FAZER' : 'FINALIZADO PACIALMENTE',
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
          color: codEtapa == 3 ? Color(0xFFFE8D00) : Color(0xFF3d7d24),
        ),
      ],
    );
  }
}
