import 'package:flutter/material.dart';
import 'package:monopoly_helper/features/game_session/presentation/game_session_frame.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';
import 'package:monopoly_helper/features/home/presentation/widgets/marquee_nav_button.dart';
import 'package:monopoly_helper/features/home/presentation/widgets/navigation_panel.dart';
import 'package:monopoly_helper/features/home/presentation/widgets/player_status_bar.dart';

/// The app's only screen.
///
/// Structure, top to bottom, is a plain [Column] (not a [Scaffold] with a
/// `drawer`) so that both the player status bar and the pinned bottom
/// button sit *outside* the area the navigation panel can slide over —
/// that's what keeps them "always visible, even when the sidebar is
/// open" without any special-casing in either of those widgets:
///
/// ```
/// Column
///  ├── PlayerStatusBar                (pinned top)
///  ├── Expanded
///  │    └── Stack
///  │         ├── GameSessionFrame     (moves -> challenge -> results)
///  │         ├── barrier (when nav open, closes it on tap)
///  │         └── NavigationPanel      (slides in/out, only within here)
///  └── MarqueeNavButton               (pinned bottom, always on top)
/// ```
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GameSessionController _controller;
  bool _isNavOpen = false;

  static const double _panelWidth = 320;

  @override
  void initState() {
    super.initState();
    _controller = GameSessionController();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() => setState(() {});

  void _toggleNav() => setState(() => _isNavOpen = !_isNavOpen);

  void _closeNav() {
    if (_isNavOpen) setState(() => _isNavOpen = false);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final panelWidth = _panelWidth.clamp(0, MediaQuery.sizeOf(context).width * 0.88).toDouble();

    return Scaffold(
      body: Column(
        children: [
          PlayerStatusBar(
            players: _controller.players,
            activePlayerIndex: _controller.activePlayerIndex,
            activePlayerDisplayPositionOverride:
                _controller.activePlayerDisplayPositionOverride,
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: GameSessionFrame(controller: _controller),
                ),
                if (_isNavOpen)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _closeNav,
                      child: Container(color: Colors.black.withValues(alpha: 0.45)),
                    ),
                  ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  top: 0,
                  bottom: 0,
                  width: panelWidth,
                  left: isRtl ? null : (_isNavOpen ? 0 : -panelWidth),
                  right: isRtl ? (_isNavOpen ? 0 : -panelWidth) : null,
                  child: Material(
                    elevation: 16,
                    child: const NavigationPanel(),
                  ),
                ),
              ],
            ),
          ),
          MarqueeNavButton(isOpen: _isNavOpen, onToggle: _toggleNav),
        ],
      ),
    );
  }
}
