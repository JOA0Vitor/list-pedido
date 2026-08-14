import 'package:flutter/material.dart';

class SummaryStat extends StatelessWidget {
  const SummaryStat({
    super.key,
    required this.label,
    required this.value,
    this.trend,
  });

  final String label;
  final String value;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 18, color: Colors.grey[300]),
        ),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
        if (trend != null)
          Text(
            trend!,
            style: const TextStyle(fontSize: 14, color: Color(0xFFa1efff)),
          ),
      ],
    );
  }
}
