import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/models/city_model.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/end_turn_button.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Results-page content for Start, Express Bus, and a "just visiting"
/// landing on the prison tile (not an arrest) — nothing to buy or sell,
/// just a short note and the shared end-turn button.
class PassthroughTileContent extends StatelessWidget {
  const PassthroughTileContent(
      {super.key, required this.controller, required this.city});

  final GameSessionController controller;
  final CityModel city;

  String get _message => switch (city.kind) {
        CityKind.start => AppStrings.passthroughStartMessage,
        CityKind.expressBus => AppStrings.passthroughExpressBusMessage,
        CityKind.prison => AppStrings.passthroughPrisonVisitMessage,
        CityKind.normal || CityKind.club => '',
      };

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10 * scale),
          child: Text(
            _message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16 * scale, color: Colors.grey),
          ),
        ),
        SizedBox(height: 10 * scale),
        EndTurnButton(controller: controller),
      ],
    );
  }
}
