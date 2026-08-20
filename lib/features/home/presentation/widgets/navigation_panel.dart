import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';

/// Content of the navigation panel opened by the pinned bottom button.
///
/// The brief only asked for the app's name to live here for now (with
/// settings / player-card editing explicitly deferred), so that's all
/// this shows. Add new sections here later; [NavigationPanel] itself
/// only needs to grow a scroll view if the content ever outgrows the
/// screen.
class NavigationPanel extends StatelessWidget {
  const NavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10 * scale),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.sports_esports, color: Colors.white, size: 24 * scale),
                  ),
                  SizedBox(width: 12 * scale),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appTitle,
                          style: TextStyle(fontSize: 19 * scale, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppStrings.appSubtitle,
                          style: TextStyle(fontSize: 11 * scale, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24 * scale),
              Text(
                AppStrings.navigationDrawerComingSoon,
                style: TextStyle(fontSize: 13 * scale, color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
