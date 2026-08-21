import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// The 3x3 "how many steps do you want to play" grid.
///
/// Row 1 (1-2-3) is tinted with the easy-tier color, row 2 (4-5-6) with
/// the medium-tier color, row 3 (7-8-9) with the hard-tier color — the
/// same banding [GameSessionController.difficultyForSteps] uses to pick a
/// mini-game once a number is tapped. Sizes itself from the space
/// [LayoutBuilder] hands it instead of a fixed size, so it always renders
/// as a clean 3x3 square without overflowing or needing to scroll.
class StepsGrid extends StatelessWidget {
  const StepsGrid({super.key, required this.onStepsSelected});

  final ValueChanged<int> onStepsSelected;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final maxSquare = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : constraints.maxWidth;
        final side = maxSquare.clamp(0, constraints.maxWidth).toDouble();

        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (i) {
                final steps = i + 1;
                final difficulty =
                    GameSessionController.difficultyForSteps(steps);
                return RepaintBoundary(
                  child: Material(
                    color: difficulty.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onStepsSelected(steps),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: difficulty.color, width: 1.4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$steps',
                          style: TextStyle(
                            fontSize: 26 * scale,
                            fontWeight: FontWeight.w900,
                            color: difficulty.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
