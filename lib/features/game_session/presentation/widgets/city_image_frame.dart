import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/models/city_model.dart';

/// The results page's city image block.
///
/// Locked to a 16:9 ratio so it can never push the rest of the results
/// page into overflow, and uses [BoxFit.cover] so the image always grows
/// to fill the whole frame (cropping instead of stretching) regardless of
/// its own aspect ratio. Two thin, disabled "rail" buttons overlap the
/// left/right edges — each is just a tooltip trigger showing which of the
/// city's two colors (physical card vs. physical board) it represents;
/// they don't do anything else.
///
/// No real city photos ship with the app yet, so a themed placeholder
/// (the city's board color + a landmark icon + its name) is shown
/// whenever `assets/images/cities/{idx}.jpg` isn't present. Simply drop a
/// JPG/PNG named after the city's index into that folder later and it
/// will be picked up automatically.
class CityImageFrame extends StatelessWidget {
  const CityImageFrame({super.key, required this.city});

  final CityModel city;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final railHeight = constraints.maxHeight * 0.4;

          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/cities/${city.idx}.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _CityPlaceholder(city: city),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _TooltipRail(
                      height: railHeight,
                      message: AppStrings.colorOnCardTooltip,
                      color: city.colorOnCard,
                      scale: scale,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _TooltipRail(
                      height: railHeight,
                      message: AppStrings.colorOnBoardTooltip,
                      color: city.colorOnBoard,
                      scale: scale,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CityPlaceholder extends StatelessWidget {
  const _CityPlaceholder({required this.city});

  final CityModel city;

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            city.colorOnBoard.withValues(alpha: 0.85),
            city.colorOnBoard.withValues(alpha: 0.45),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_city, color: Colors.white.withValues(alpha: 0.9), size: 44 * scale),
            SizedBox(height: 8 * scale),
            Text(
              city.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipRail extends StatelessWidget {
  const _TooltipRail({
    required this.height,
    required this.message,
    required this.color,
    required this.scale,
  });

  final double height;
  final String message;
  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        width: 18 * scale,
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}
