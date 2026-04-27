import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B00).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFFF8C00)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
