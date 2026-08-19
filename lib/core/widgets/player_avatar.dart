import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  final bool isInJail;
  final bool isBankrupt;

  const PlayerAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 46,
    this.isInJail = false,
    this.isBankrupt = false,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty ? name.trim().substring(0, 1).toUpperCase() : '?';

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.45,
              ),
            ),
          ),
        ),
        if (isInJail)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, size: 12, color: Colors.white),
            ),
          ),
        if (isBankrupt)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
