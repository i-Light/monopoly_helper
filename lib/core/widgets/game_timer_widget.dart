import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';

class GameTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final double size;

  const GameTimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.isRunning = true,
    this.size = 90,
  });

  Color _getTimerColor(double ratio) {
    if (ratio > 0.5) return AppColors.success;
    if (ratio > 0.2) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = totalSeconds > 0 ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;
    final color = _getTimerColor(ratio);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: ratio,
              strokeWidth: 8,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$remainingSeconds',
                style: TextStyle(
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                'ثانية',
                style: TextStyle(
                  fontSize: size * 0.13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
