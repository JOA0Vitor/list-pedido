import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  const HeaderCell(
    this.text, {
    super.key,
    required this.flex,
    required this.align,
  });

  final String text;
  final int flex;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
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
}
