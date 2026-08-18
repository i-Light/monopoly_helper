import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/sound_helper.dart';

class DiceWidget extends StatefulWidget {
  final int die1;
  final int die2;
  final bool isRolling;
  final bool isDouble;
  final int consecutiveDoubles;
  final VoidCallback onRoll;

  const DiceWidget({
    super.key,
    required this.die1,
    required this.die2,
    required this.isRolling,
    required this.isDouble,
    required this.consecutiveDoubles,
    required this.onRoll,
  });

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(covariant DiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _animController.forward(from: 0.0);
      SoundHelper.playRollDice();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildDieFace(int value) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(2, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Center(
        child: _buildDieDots(value),
      ),
    );
  }

  Widget _buildDieDots(int value) {
    const dotColor = Color(0xFFD32F2F);
    const dotSize = 11.0;

    Widget dot() => Container(
          width: dotSize,
          height: dotSize,
          decoration: const BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        );

    Widget empty() => const SizedBox(width: dotSize, height: dotSize);

    List<List<bool>> dotMatrix;
    switch (value) {
      case 1:
        dotMatrix = [
          [false, false, false],
          [false, true, false],
          [false, false, false],
        ];
        break;
      case 2:
        dotMatrix = [
          [true, false, false],
          [false, false, false],
          [false, false, true],
        ];
        break;
      case 3:
        dotMatrix = [
          [true, false, false],
          [false, true, false],
          [false, false, true],
        ];
        break;
      case 4:
        dotMatrix = [
          [true, false, true],
          [false, false, false],
          [true, false, true],
        ];
        break;
      case 5:
        dotMatrix = [
          [true, false, true],
          [false, true, false],
          [true, false, true],
        ];
        break;
      case 6:
      default:
        dotMatrix = [
          [true, false, true],
          [true, false, true],
          [true, false, true],
        ];
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dotMatrix.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row.map((hasDot) => hasDot ? dot() : empty()).toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.die1 + widget.die2;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final angle = _animController.value * 2 * pi;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: widget.isRolling ? angle : 0,
                  child: _buildDieFace(widget.die1),
                ),
                const SizedBox(width: 20),
                Transform.rotate(
                  angle: widget.isRolling ? -angle : 0,
                  child: _buildDieFace(widget.die2),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary, width: 1.2),
              ),
              child: Text(
                'المجموع: $total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            if (widget.isDouble) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary, width: 1.2),
                ),
                child: Text(
                  '🎉 زوجي (${widget.consecutiveDoubles})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: widget.isRolling ? null : widget.onRoll,
          icon: const Icon(Icons.casino, size: 22),
          label: Text(widget.isRolling ? 'جاري الرمي...' : 'ارمي النرد'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
