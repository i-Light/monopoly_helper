import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/datasets/cities_data.dart';
import 'package:monopoly_helper/data/models/player_model.dart';

/// The pinned, always-visible row of players at the very top of the app.
///
/// Stays on screen no matter which of the three turn-loop pages is
/// showing, and no matter whether the navigation drawer is open — it's
/// rendered by [HomeScreen] outside of both. The active player is
/// auto-scrolled to the horizontal center and shown at full opacity;
/// everyone else is dimmed.
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
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};

  @override
  void didUpdateWidget(covariant PlayerStatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activePlayerIndex != widget.activePlayerIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerActiveCard());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerActiveCard());
  }

  void _centerActiveCard() {
    final key = _cardKeys[widget.activePlayerIndex];
    final cardContext = key?.currentContext;
    if (cardContext == null) return;

    Scrollable.ensureVisible(
      cardContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 10 * scale),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 66 * scale,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14 * scale),
            itemCount: widget.players.length,
            separatorBuilder: (context, index) => SizedBox(width: 10 * scale),
            itemBuilder: (context, index) {
              final player = widget.players[index];
              final isActive = index == widget.activePlayerIndex;
              final key = _cardKeys.putIfAbsent(index, () => GlobalKey());
              final cityName = CitiesData.byIndex(player.position).name;

              return AnimatedOpacity(
                key: key,
                opacity: isActive ? 1.0 : 0.45,
                duration: const Duration(milliseconds: 250),
                child: AnimatedScale(
                  scale: isActive ? 1.0 : 0.92,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 6 * scale),
                    decoration: BoxDecoration(
                      color: player.color.withValues(alpha: isActive ? 0.9 : 0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: isActive
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: player.color.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13 * scale,
                          ),
                        ),
                        SizedBox(height: 2 * scale),
                        Text(
                          cityName.isEmpty ? AppStrings.playerPositionUnknown : cityName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
