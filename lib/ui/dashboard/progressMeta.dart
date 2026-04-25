import 'package:flutter/material.dart';

class ProgressMeta extends StatelessWidget {
  final double progress;
  const ProgressMeta({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('META', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 4),
        Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}