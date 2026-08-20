import 'dart:math';
import 'package:flutter/material.dart';

/// Which color palette a [ConfettiOverlay] burst should use.
enum ConfettiPalette {
  /// Bright, varied colors — used when a player wins a challenge outright.
  colorful,

  /// Shades of gold/amber — used when a player pays to move despite
  /// losing the challenge.
  golden,
}

/// A self-contained confetti burst, painted by hand with [CustomPainter]
/// so the app doesn't need a pub.dev package to celebrate a win.
///
/// Usage: place a [ConfettiOverlay] in a [Stack] on top of the results
/// page and flip [play] to `true` (e.g. via a [ValueKey] change or simply
/// rebuilding with a new `play` value) whenever a new result should
/// celebrate.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    required this.play,
    this.palette = ConfettiPalette.colorful,
    this.particleCount = 140,
  });

  /// Fires a one-off confetti burst on top of everything currently on
  /// screen, regardless of which page called it. Unlike embedding a
  /// [ConfettiOverlay] directly in a page's [Stack], this doesn't tie the
  /// celebration to any one screen — any screen can call this and the
  /// burst removes itself once it finishes playing.
  static void fire(
    BuildContext context, {
    ConfettiPalette palette = ConfettiPalette.colorful,
    int particleCount = 140,
  }) {
    final overlayState = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: ConfettiOverlay(
          play: true,
          palette: palette,
          particleCount: particleCount,
        ),
      ),
    );
    overlayState.insert(entry);
    Future.delayed(const Duration(milliseconds: 2700), entry.remove);
  }

  /// Starts (or restarts, via a new key from the parent) the burst when
  /// true. When false, nothing is painted.
  final bool play;

  final ConfettiPalette palette;

  final int particleCount;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  List<_ConfettiParticle> _particles = const [];

  static const List<Color> _colorfulPalette = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFF8E24AA),
    Color(0xFFFB8C00),
    Color(0xFF00ACC1),
  ];

  static const List<Color> _goldenPalette = [
    Color(0xFFFFD700),
    Color(0xFFFFC107),
    Color(0xFFFFB300),
    Color(0xFFFFE082),
    Color(0xFFF9A825),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.play) _start();
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final justStarted = widget.play && !oldWidget.play;
    final paletteChangedWhilePlaying =
        widget.play && oldWidget.palette != widget.palette;
    if (justStarted || paletteChangedWhilePlaying) _start();
    if (!widget.play) _controller.stop();
  }

  void _start() {
    final random = Random();
    final palette =
        widget.palette == ConfettiPalette.golden ? _goldenPalette : _colorfulPalette;
    _particles = List.generate(widget.particleCount, (_) {
      return _ConfettiParticle(
        color: palette[random.nextInt(palette.length)],
        startX: random.nextDouble(),
        fallDelay: random.nextDouble() * 0.35,
        fallSpeed: 0.75 + random.nextDouble() * 0.5,
        horizontalDrift: (random.nextDouble() - 0.5) * 0.5,
        rotationSpeed: (random.nextDouble() - 0.5) * 10,
        size: 6 + random.nextDouble() * 7,
        isRectangle: random.nextBool(),
      );
    });
    _controller
      ..reset()
      ..forward();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play || _particles.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  _ConfettiParticle({
    required this.color,
    required this.startX,
    required this.fallDelay,
    required this.fallSpeed,
    required this.horizontalDrift,
    required this.rotationSpeed,
    required this.size,
    required this.isRectangle,
  });

  final Color color;
  final double startX;
  final double fallDelay;
  final double fallSpeed;
  final double horizontalDrift;
  final double rotationSpeed;
  final double size;
  final bool isRectangle;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final localProgress =
          ((progress - particle.fallDelay) / (1 - particle.fallDelay)).clamp(0.0, 1.0).toDouble();
      if (localProgress <= 0) continue;

      final eased = Curves.easeIn.transform(localProgress);
      final dy = eased * size.height * particle.fallSpeed;
      final dx = particle.startX * size.width +
          sin(eased * pi * 2) * particle.horizontalDrift * size.width * 0.15;
      final opacity = (1 - eased).clamp(0.0, 1.0).toDouble();
      final angle = eased * particle.rotationSpeed * pi;

      paint.color = particle.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      if (particle.isRectangle) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 0.5,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, particle.size * 0.4, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.particles != particles;
}
