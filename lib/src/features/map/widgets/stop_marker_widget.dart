import 'package:flutter/material.dart';
import '../models/stop_model.dart';

class StopMarkerWidget extends StatelessWidget {
  final StopModel stop;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const StopMarkerWidget({
    super.key,
    required this.stop,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isHighlighted
        ? const Color(0xFF2563EB)
        : const Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
