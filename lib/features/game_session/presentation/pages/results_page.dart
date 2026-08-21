import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/constants/game_constants.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/core/widgets/confetti_overlay.dart';
import 'package:monopoly_helper/core/widgets/scale_to_fit.dart';
import 'package:monopoly_helper/data/models/city_model.dart';
import 'package:monopoly_helper/features/game_session/presentation/special_tiles/club/club_subscribers_badge.dart';
import 'package:monopoly_helper/features/game_session/presentation/special_tiles/club/club_tile_content.dart';
import 'package:monopoly_helper/features/game_session/presentation/special_tiles/passthrough_tile_content.dart';
import 'package:monopoly_helper/features/game_session/presentation/special_tiles/prison/prison_arrest_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/special_tiles/prison/prison_challenge_outcome_view.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/city_action_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/city_image_frame.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/end_turn_button.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/owner_badge.dart';
import 'package:monopoly_helper/features/game_session/presentation/widgets/pay_fee_button.dart';
import 'package:monopoly_helper/features/game_session/state/game_session_controller.dart';

/// Stage 3 of the main frame: shows what happened, where the player's
/// piece should physically move to (or that they're staying put), the
/// city's image, and the buy/pay actions that end the turn — except for
/// the four special tiles (Start/Club/Express Bus/Prison), whose content
/// is delegated to `presentation/special_tiles/` instead of the generic
/// buy/base/garage/market flow below. A resolved prison escape challenge
/// (no real city involved) short-circuits to [PrisonChallengeOutcomeView]
/// before any of that.
///
/// Like the challenge page, the whole body is wrapped in [ScaleToFit]
/// rather than relying on [Expanded] to absorb the image's height: the
/// number of buy buttons shown here varies (two vs. four), so a fixed
/// flex split isn't safe on short screens — scaling the whole block down
/// to fit is.
class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.controller});

  final GameSessionController controller;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  GameSessionController get controller => widget.controller;
  bool _confettiFiredForThisVisit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeFireConfetti());
  }

  @override
  void didUpdateWidget(covariant ResultsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.moveResolution == MoveResolution.none) {
      _confettiFiredForThisVisit = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeFireConfetti());
  }

  void _maybeFireConfetti() {
    if (!mounted || _confettiFiredForThisVisit) return;
    final resolved = controller.moveResolution == MoveResolution.wonFree ||
        controller.moveResolution == MoveResolution.paidToMove;
    if (!resolved) return;
    _confettiFiredForThisVisit = true;
    ConfettiOverlay.fire(
      context,
      palette: controller.moveResolution == MoveResolution.paidToMove
          ? ConfettiPalette.golden
          : ConfettiPalette.colorful,
    );
  }

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
    if (controller.isPrisonChallenge) {
      return PrisonChallengeOutcomeView(controller: controller);
    }

    final scale = context.uiScale;
    final isDesktop = context.isDesktop;
    final city = controller.relevantCity;

    final Widget badgeSlot;
    final Widget middleContent;
    switch (city.kind) {
      case CityKind.club:
        badgeSlot = ClubSubscribersBadge(
          subscribers: controller.clubSubscribers,
          capacity: GameConstants.clubSubscriberCapacity,
        );
        middleContent = ClubTileContent(controller: controller);
      case CityKind.start:
      case CityKind.expressBus:
      case CityKind.prison:
        // Owner is always null for these three — nobody's ownedCityIndices
        // ever contains their index — so OwnerBadge renders its existing
        // empty-Container no-op.
        badgeSlot = OwnerBadge(owner: controller.ownerOfRelevantCity);
        middleContent = PassthroughTileContent(controller: controller, city: city);
      case CityKind.normal:
        badgeSlot = OwnerBadge(owner: controller.ownerOfRelevantCity);
        middleContent = controller.relevantCityOwnedByOther
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CityActionButton(
                    icon: Icons.handshake,
                    buyLabel: AppStrings.buyFromOwner,
                    boughtLabel: AppStrings.buyFromOwner,
                    price: city.basePrice,
                    fee: city.baseFee,
                    isOwned: false,
                    canAfford: !controller.hasActedThisVisit &&
                        controller.canAffordBase,
                    onTap: controller.buyFromOwner,
                  ),
                  const SizedBox(height: 8),
                  PayFeeButton(
                    fee: controller.feeOwedToOwner,
                    canAfford: !controller.hasActedThisVisit &&
                        controller.canAffordFee,
                    onTap: controller.payOwnerAndFinishTurn,
                  ),
                  if (controller.canChooseArrest) ...[
                    const SizedBox(height: 8),
                    PrisonArrestButton(controller: controller),
                  ],
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CityActionButton(
                    icon: Icons.location_city,
                    buyLabel: AppStrings.buyCity,
                    boughtLabel: AppStrings.citySold,
                    price: city.basePrice,
                    fee: city.baseFee,
                    isOwned: controller.activePlayer
                        .ownsCity(controller.relevantCityIndex),
                    canAfford: !controller.hasActedThisVisit &&
                        controller.canAffordBase,
                    onTap: controller.buyBase,
                  ),
                  const SizedBox(height: 8),
                  // Garage stays visible even before the base plot is
                  // owned, but isn't tappable until then.
                  CityActionButton(
                    icon: Icons.garage,
                    buyLabel: AppStrings.buyGarage,
                    boughtLabel: AppStrings.garageSold,
                    price: city.garagePrice,
                    fee: city.garageFee,
                    isOwned: controller.activePlayer
                        .ownsGarage(controller.relevantCityIndex),
                    canAfford: controller.canBuyGarage,
                    onTap: controller.buyGarage,
                  ),
                  // Market only appears at all once the garage is owned.
                  if (controller.marketPurchaseUnlocked) ...[
                    const SizedBox(height: 8),
                    CityActionButton(
                      icon: Icons.storefront,
                      buyLabel: AppStrings.buyMarket,
                      boughtLabel: AppStrings.marketSold,
                      price: city.marketPrice,
                      fee: city.marketFee,
                      isOwned: controller.activePlayer
                          .ownsMarket(controller.relevantCityIndex),
                      canAfford: controller.canBuyMarket,
                      onTap: controller.buyMarket,
                    ),
                  ],
                  const SizedBox(height: 10),
                  EndTurnButton(controller: controller),
                ],
              );
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(16 * scale),
          // SizedBox.expand gives ScaleToFit tight bounds (rather than the
          // loose ones a bare Center would provide), so its BoxFit.contain
          // actually scales the content up to fill the available space
          // instead of shrink-wrapping it at referenceWidth and leaving
          // the rest of the page empty.
          child: SizedBox.expand(
            child: ScaleToFit(
              referenceWidth: isDesktop ? 460 : 380,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.playerMovedThisTurn
                              ? '${AppStrings.goToCityPrefix} ${city.name}'
                              : '${AppStrings.stayAtCityPrefix} ${city.name}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                      badgeSlot,
                    ],
                  ),
                  const SizedBox(height: 14),
                  CityImageFrame(city: city),
                  const SizedBox(height: 14),
                  middleContent,
                ],
              ),
            ),
          ),
        ),
        if (controller.moveResolution == MoveResolution.wonFree)
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
                child: _WinToast(key: ValueKey(controller.activePlayerIndex))),
          ),
      ],
    );
  }
}

/// A pill that flies in, holds briefly, then fades away on its own —
/// used instead of a static banner so "won for free" reads as a
/// celebratory pop-up rather than permanent page furniture.
class _WinToast extends StatefulWidget {
  const _WinToast({super.key});

  @override
  State<_WinToast> createState() => _WinToastState();
}

class _WinToastState extends State<_WinToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // In for the first 15%, held, then fades out over the last 25%.
        final opacity = t < 0.15
            ? (t / 0.15)
            : t > 0.75
                ? (1 - (t - 0.75) / 0.25).clamp(0.0, 1.0)
                : 1.0;
        final scale = 0.85 + 0.15 * (t < 0.15 ? (t / 0.15) : 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: const Text(
          AppStrings.resultWonHeadline,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
