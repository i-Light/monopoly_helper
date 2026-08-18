import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'features/dashboard/presentation/main_dashboard_screen.dart';
import 'features/player_management/presentation/player_list_screen.dart';
import 'features/mini_games/presentation/mini_games_hub_screen.dart';
import 'features/chance_community/presentation/cards_deck_screen.dart';
import 'features/history/presentation/game_log_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

class AppNavigationShell extends StatefulWidget {
  const AppNavigationShell({super.key});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MainDashboardScreen(),
    PlayerListScreen(),
    MiniGamesHubScreen(),
    CardsDeckScreen(),
    GameLogScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 720;

        if (isWideScreen) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: AppColors.primary),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text(AppStrings.navDashboard),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text(AppStrings.navPlayers),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sports_esports_outlined),
                      selectedIcon: Icon(Icons.sports_esports),
                      label: Text(AppStrings.navMiniGames),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.style_outlined),
                      selectedIcon: Icon(Icons.style),
                      label: Text(AppStrings.navCards),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history_outlined),
                      selectedIcon: Icon(Icons.history),
                      label: Text(AppStrings.navHistory),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text(AppStrings.navSettings),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_currentIndex]),
              ],
            ),
          );
        }

        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            indicatorColor: AppColors.primary.withOpacity(0.25),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
                label: AppStrings.navDashboard,
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people, color: AppColors.primary),
                label: AppStrings.navPlayers,
              ),
              NavigationDestination(
                icon: Icon(Icons.sports_esports_outlined),
                selectedIcon: Icon(Icons.sports_esports, color: AppColors.primary),
                label: AppStrings.navMiniGames,
              ),
              NavigationDestination(
                icon: Icon(Icons.style_outlined),
                selectedIcon: Icon(Icons.style, color: AppColors.primary),
                label: AppStrings.navCards,
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history, color: AppColors.primary),
                label: AppStrings.navHistory,
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings, color: AppColors.primary),
                label: AppStrings.navSettings,
              ),
            ],
          ),
        );
      },
    );
  }
}
