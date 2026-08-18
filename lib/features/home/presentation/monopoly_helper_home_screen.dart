import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/features/home/state/mini_game_state.dart';
import 'package:monopoly_helper/features/home/presentation/widgets/game_sidebar.dart';
import 'package:monopoly_helper/features/home/presentation/widgets/game_stage_panel.dart';

class MonopolyHelperHomeScreen extends StatelessWidget {
  const MonopolyHelperHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 780;

        if (isDesktop) {
          // PC / Desktop / Web Split Master-Detail Layout
          return const Scaffold(
            body: Row(
              children: [
                GameSidebar(),
                Expanded(child: GameStagePanel()),
              ],
            ),
          );
        }

        // Mobile / Phone View with Drawer & Responsive Controls
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.shuffle),
                tooltip: AppStrings.randomGame,
                onPressed: () => context.read<MiniGameState>().pickRandomGame(),
              ),
            ],
          ),
          drawer: const Drawer(
            child: SafeArea(
              child: GameSidebar(),
            ),
          ),
          body: const GameStagePanel(),
        );
      },
    );
  }
}
