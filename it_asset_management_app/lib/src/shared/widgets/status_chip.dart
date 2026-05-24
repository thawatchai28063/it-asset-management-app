import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'in_use':
        return Colors.blue;
      case 'repair':
      case 'in_progress':
        return Colors.orange;
      case 'retired':
        return Colors.grey;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.deepOrange;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.replaceAll('_', ' ')),
      visualDensity: VisualDensity.compact,
      backgroundColor: _color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: _color, fontWeight: FontWeight.w700),
    );
  }
}
