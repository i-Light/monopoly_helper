import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/confetti_overlay.dart';
import 'package:monopoly_helper/core/widgets/scale_to_fit.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/city_action_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/city_image_frame.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/owner_badge.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Stage 3 of the main frame: shows what happened, where the player's
/// piece should physically move to (or that they're staying put), the
/// city's image, and the buy/pay actions that end the turn.
///
/// Like the challenge page, the whole body is wrapped in [ScaleToFit]
/// rather than relying on [Expanded] to absorb the image's height: the
/// number of buy buttons shown here varies (two vs. four), so a fixed
/// flex split isn't safe on short screens — scaling the whole block down
/// to fit is.
class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.controller});

  final GameSessionController controller;

  String get _headline {
    switch (controller.moveResolution) {
      case MoveResolution.wonFree:
        return AppStrings.resultWonHeadline;
      case MoveResolution.paidToMove:
        return AppStrings.resultPaidHeadline;
      case MoveResolution.stayed:
      case MoveResolution.none:
        return AppStrings.resultStayedHeadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    final isDesktop = context.isDesktop;
    final city = controller.relevantCity;
    final owner = controller.ownerOfRelevantCity;
    final ownedByOther = controller.relevantCityOwnedByOther;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(16 * scale),
          child: Center(
            child: ScaleToFit(
              referenceWidth: isDesktop ? 460 : 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.playerMovedThisTurn
                              ? '${AppStrings.goToCityPrefix} ${city.name}'
                              : '${AppStrings.stayAtCityPrefix} ${city.name}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (owner != null) OwnerBadge(owner: owner),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CityImageFrame(city: city),
                  const SizedBox(height: 14),
                  if (ownedByOther) ...[
                    CityActionButton(
                      icon: Icons.handshake,
                      buyLabel: AppStrings.buyFromOwner,
                      boughtLabel: AppStrings.buyFromOwner,
                      price: city.basePrice,
                      fee: city.baseFee,
                      isOwned: false,
                      canAfford: controller.activePlayer.balance >= city.basePrice,
                      onTap: controller.buyFromOwner,
                    ),
                    const SizedBox(height: 8),
                    CityActionButton(
                      icon: Icons.payments,
                      buyLabel: AppStrings.payOwnerAndFinish,
                      boughtLabel: AppStrings.payOwnerAndFinish,
                      price: city.baseFee,
                      fee: 0,
                      isOwned: false,
                      canAfford: controller.activePlayer.balance >= city.baseFee,
                      onTap: controller.payOwnerAndFinishTurn,
                    ),
                  ] else ...[
                    CityActionButton(
                      icon: Icons.location_city,
                      buyLabel: AppStrings.buyCity,
                      boughtLabel: AppStrings.citySold,
                      price: city.basePrice,
                      fee: city.baseFee,
                      isOwned: controller.activePlayer.ownsCity(controller.relevantCityIndex),
                      canAfford: controller.canAffordBase,
                      onTap: controller.buyBase,
                    ),
                    const SizedBox(height: 8),
                    CityActionButton(
                      icon: Icons.garage,
                      buyLabel: AppStrings.buyGarage,
                      boughtLabel: AppStrings.garageSold,
                      price: city.garagePrice,
                      fee: city.garageFee,
                      isOwned: controller.activePlayer.ownsGarage(controller.relevantCityIndex),
                      canAfford: controller.canAffordGarage,
                      onTap: controller.buyGarage,
                    ),
                    const SizedBox(height: 8),
                    CityActionButton(
                      icon: Icons.storefront,
                      buyLabel: AppStrings.buyMarket,
                      boughtLabel: AppStrings.marketSold,
                      price: city.marketPrice,
                      fee: city.marketFee,
                      isOwned: controller.activePlayer.ownsMarket(controller.relevantCityIndex),
                      canAfford: controller.canAffordMarket,
                      onTap: controller.buyMarket,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: controller.finishTurn,
                      icon: const Icon(Icons.flag_circle, size: 18),
                      label: const Text(AppStrings.endTurn, style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 46),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ConfettiOverlay(
            play: controller.moveResolution == MoveResolution.wonFree ||
                controller.moveResolution == MoveResolution.paidToMove,
            palette: controller.moveResolution == MoveResolution.paidToMove
                ? ConfettiPalette.golden
                : ConfettiPalette.colorful,
          ),
        ),
      ],
    );
  }
}
