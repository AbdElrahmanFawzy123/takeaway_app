import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: primary
              ? const LinearGradient(
                  colors: [Color(0xFFFF8C00), Color(0xFFFF4500)])
              : null,
          border: primary ? null : Border.all(color: const Color(0xFFFF8C00)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? Colors.white : const Color(0xFFFF8C00)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: primary ? Colors.white : const Color(0xFFFF8C00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
