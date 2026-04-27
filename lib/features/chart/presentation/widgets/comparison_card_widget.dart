import 'package:flutter/material.dart';

class ComparisonCard extends StatelessWidget {
  final String label;
  final double? single;
  final double? doubleVal;
  final String unit;
  final bool isPercentage;

  const ComparisonCard({
    super.key,
    required this.label,
    required this.single,
    required this.doubleVal,
    required this.unit,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121215),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          /// LABEL
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// SINGLE BOX
          Expanded(
            flex: 1,
            child: _buildValueBox(
              title: "Single",
              value: single,
              color: const Color(0xFFFF8C00),
            ),
          ),

          const SizedBox(width: 10),

          /// DOUBLE BOX
          Expanded(
            flex: 1,
            child: _buildValueBox(
              title: "Double",
              value: doubleVal,
              color: const Color(0xFF44DD88),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueBox({
    required String title,
    required double? value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value != null
                ? isPercentage
                    ? '${(value * 100).toStringAsFixed(1)}%'
                    : '${value.toStringAsFixed(2)}\n$unit'
                : '—',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
