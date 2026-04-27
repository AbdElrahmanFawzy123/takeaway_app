import 'package:flutter/material.dart';

class RunSimulationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const RunSimulationButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLoading ? Icons.hourglass_empty : Icons.compare_arrows,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                isLoading ? 'Running...' : 'Run Both Systems 🔥',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
