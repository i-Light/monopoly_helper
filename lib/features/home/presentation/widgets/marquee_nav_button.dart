import 'dart:math';
import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';
import 'package:monopoly_helper/data/datasets/mini_games/navigation_tips_data.dart';

/// The pinned button at the very bottom of the app that opens/closes the
/// navigation drawer.
///
/// A fixed icon sits on the left; to its right, a line of text glides
/// slowly from the right edge of the button to the left. Once it fully
/// leaves the screen a new random line (from [NavigationTipsData]) starts
/// again from the right — forever. The whole button (icon, moving text,
/// and the empty space around them) is one big tap target; the animated
/// text itself never intercepts touches, so it can never block the tap
/// that opens the drawer.
class MarqueeNavButton extends StatefulWidget {
  const MarqueeNavButton(
      {super.key, required this.isOpen, required this.onToggle});

  final bool isOpen;
  final VoidCallback onToggle;

  @override
  State<MarqueeNavButton> createState() => _MarqueeNavButtonState();
}

class _MarqueeNavButtonState extends State<MarqueeNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _currentText;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentText = _pickNextText(null);
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _advanceText();
      });
  }

  String _pickNextText(String? avoid) {
    final tips = NavigationTipsData.tips;
    if (tips.length <= 1) return tips.first;
    String candidate;
    do {
      candidate = tips[_random.nextInt(tips.length)];
    } while (candidate == avoid);
    return candidate;
  }

  void _advanceText() {
    setState(() => _currentText = _pickNextText(_currentText));
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    const iconSlot = 52.0;
    final fontSize = 16 * scale;

    return SafeArea(
      top: false,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(12 * scale, 6 * scale, 12 * scale, 10 * scale),
        child: RepaintBoundary(
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onToggle,
              child: SizedBox(
                height: 52 * scale,
                width: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    // Fixed icon slot — always visible, never covered by text.
                    Positioned(
                      left: 14 * scale,
                      child: Icon(
                        widget.isOpen ? Icons.close : Icons.menu_open,
                        color: Colors.white,
                        size: 22 * scale,
                      ),
                    ),
                    // Gliding text, clipped so it never overlaps the icon.
                    Positioned.fill(
                      left: iconSlot * scale,
                      child: ClipRect(
                        child: IgnorePointer(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final textPainter = TextPainter(
                                text: TextSpan(
                                  text: _currentText,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                textDirection: TextDirection.rtl,
                              )..layout();
                              final textWidth = textPainter.width;
                              // Moves left-to-right: starts fully off-screen
                              // to the left, ends fully off-screen to the
                              // right. Logical pixels are already
                              // device-pixel-ratio independent, so driving
                              // the duration from a constant px/second speed
                              // (instead of the old "chars * ms" guess) keeps
                              // the glide at the same real-world speed no
                              // matter the text length or screen density.
                              final startX = -textWidth;
                              final endX = constraints.maxWidth;
                              const pixelsPerSecond = 90.0;
                              final durationMs =
                                  (((endX - startX) / pixelsPerSecond) * 1000)
                                      .clamp(2000, 20000)
                                      .toInt();
                              if (_controller.duration?.inMilliseconds !=
                                  durationMs) {
                                _controller.duration =
                                    Duration(milliseconds: durationMs);
                              }
                              if (!_controller.isAnimating) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted && !_controller.isAnimating)
                                    _controller.forward();
                                });
                              }

                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) {
                                  final dx = startX +
                                      (endX - startX) * _controller.value;
                                  return Transform.translate(
                                    offset: Offset(dx, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _currentText,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
