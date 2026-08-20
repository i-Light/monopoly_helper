import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/datasets/cities_data.dart';
import 'package:monopoly_helper/data/models/player_model.dart';

/// The pinned, always-visible row of players at the very top of the app.
///
/// Stays on screen no matter which of the three turn-loop pages is
/// showing, and no matter whether the navigation drawer is open — it's
/// rendered by [HomeScreen] outside of both. Cards fill the row's full
/// width evenly. The active player is shown at full opacity; everyone
/// else is dimmed. Tapping anywhere on the bar toggles a compact mode
/// that collapses each card down to a thin color strip.
class PlayerStatusBar extends StatefulWidget {
  const PlayerStatusBar({
    super.key,
    required this.players,
    required this.activePlayerIndex,
  });

  final List<PlayerModel> players;
  final int activePlayerIndex;

  @override
  State<PlayerStatusBar> createState() => _PlayerStatusBarState();
}

class _PlayerStatusBarState extends State<PlayerStatusBar> {
  final Map<int, GlobalKey> _cardKeys = {};
  bool _compact = false;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _compact = !_compact),
      child: Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.symmetric(vertical: (_compact ? 6 : 10) * scale),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: (_compact ? 14 : 58) * scale,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14 * scale),
              child: Row(
                children: List.generate(widget.players.length, (index) {
                  final player = widget.players[index];
                  final isActive = index == widget.activePlayerIndex;
                  final key = _cardKeys.putIfAbsent(index, () => GlobalKey());
                  final cityName = CitiesData.byIndex(player.position).name;

                  return Expanded(
                    key: key,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4 * scale),
                      child: AnimatedOpacity(
                        opacity: isActive ? 1.0 : 0.45,
                        duration: const Duration(milliseconds: 250),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          height: (_compact ? 6 : 50) * scale,
                          padding: _compact
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 4 * scale),
                          decoration: BoxDecoration(
                            color: player.color.withValues(alpha: isActive ? 0.9 : 0.55),
                            borderRadius: BorderRadius.circular(_compact ? 4 : 12),
                            border: isActive
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: player.color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: _compact
                              ? null
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      player.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11 * scale,
                                      ),
                                    ),
                                    Text(
                                      cityName.isEmpty
                                          ? AppStrings.playerPositionUnknown
                                          : cityName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 9 * scale,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
