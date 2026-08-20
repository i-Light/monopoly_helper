import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/difficulty_badge.dart';
import 'package:monopoly_helper/features/mini_games/core/base_mini_game.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_difficulty.dart';
import 'package:monopoly_helper/features/mini_games/core/mini_game_manager.dart';

/// The filterable "pick a mini-game" list.
///
/// This is what used to be the always-visible left sidebar on desktop /
/// drawer on mobile. It's now opened on demand (from the "new challenge"
/// button on the challenge page) as a modal sheet, and no longer carries
/// the old footer that toggled the theme and showed a win counter — that
/// bar was removed per the redesign brief.
class ChallengePickerPanel extends StatefulWidget {
  const ChallengePickerPanel({
    super.key,
    required this.onGameSelected,
    this.initialDifficulty,
  });

  final ValueChanged<BaseMiniGame> onGameSelected;
  final MiniGameDifficulty? initialDifficulty;

  @override
  State<ChallengePickerPanel> createState() => _ChallengePickerPanelState();
}

class _ChallengePickerPanelState extends State<ChallengePickerPanel> {
  final MiniGameManager _manager = MiniGameManager();
  MiniGameDifficulty? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialDifficulty;
  }

  List<BaseMiniGame> get _games => _manager.getGamesByDifficulty(_filter);

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16 * scale, 14 * scale, 16 * scale, 6 * scale),
          child: Row(
            children: [
              Icon(Icons.sports_esports, color: AppColors.primary, size: 20 * scale),
              SizedBox(width: 8 * scale),
              Text(
                AppStrings.challengePickerTitle,
                style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipButton(
                  label: AppStrings.allDifficulties,
                  selected: _filter == null,
                  color: AppColors.primary,
                  onTap: () => setState(() => _filter = null),
                ),
                SizedBox(width: 6 * scale),
                _FilterChipButton(
                  label: AppStrings.easy,
                  selected: _filter == MiniGameDifficulty.easy,
                  color: AppColors.easyTier,
                  onTap: () => setState(() => _filter = MiniGameDifficulty.easy),
                ),
                SizedBox(width: 6 * scale),
                _FilterChipButton(
                  label: AppStrings.medium,
                  selected: _filter == MiniGameDifficulty.medium,
                  color: AppColors.mediumTier,
                  onTap: () => setState(() => _filter = MiniGameDifficulty.medium),
                ),
                SizedBox(width: 6 * scale),
                _FilterChipButton(
                  label: AppStrings.hard,
                  selected: _filter == MiniGameDifficulty.hard,
                  color: AppColors.hardTier,
                  onTap: () => setState(() => _filter = MiniGameDifficulty.hard),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 4 * scale),
          child: ElevatedButton.icon(
            onPressed: () {
              final candidates = _games;
              if (candidates.isEmpty) return;
              candidates.shuffle();
              widget.onGameSelected(candidates.first);
            },
            icon: Icon(Icons.shuffle, size: 18 * scale),
            label: Text(
              AppStrings.randomGame,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13 * scale),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 42 * scale),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(height: 4 * scale),
        const Divider(height: 1),
        Flexible(
          child: _games.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(24 * scale),
                  child: Text(
                    AppStrings.noGamesForFilter,
                    style: TextStyle(fontSize: 13 * scale, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 4 * scale, horizontal: 6 * scale),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    final game = _games[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2 * scale),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => widget.onGameSelected(game),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 8 * scale),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: game.difficulty.color.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              children: [
                                Icon(game.icon, color: game.difficulty.color, size: 20 * scale),
                                SizedBox(width: 8 * scale),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game.title,
                                        style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${game.timeLimitSeconds} ${AppStrings.seconds}',
                                        style: TextStyle(fontSize: 11 * scale, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                DifficultyBadge(difficulty: game.difficulty),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 12 * scale)),
      selected: selected,
      selectedColor: color.withValues(alpha: 0.25),
      showCheckmark: false,
      onSelected: (_) => onTap(),
    );
  }
}
