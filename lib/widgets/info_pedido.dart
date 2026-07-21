import 'package:flutter/material.dart';

class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  const InfoColumn({
    super.key,
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF677383),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        label != 'DATA'
            ? Text(value, style: valueStyle)
            : Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(value, style: valueStyle),
              ),

        // Text(value, style: valueStyle),
      ],
    );
  }
}
