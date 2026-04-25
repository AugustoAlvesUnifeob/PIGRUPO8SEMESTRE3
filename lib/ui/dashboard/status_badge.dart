import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  const StatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'LIGADO' : 'DESLIGADO',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}