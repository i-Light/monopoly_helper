import 'package:flutter/material.dart';

/// Lays [child] out at [referenceWidth] and then scales the whole thing
/// down (never up) so it always fits inside whatever space is available,
/// without clipping and without needing a scroll view.
///
/// This is the main tool used to satisfy "nothing should ever be cut off
/// or scrollable" for content whose height can vary a lot (for example a
/// mini-game that has five answer rows vs. one that has two). Instead of
/// tuning every mini-game's font sizes by hand for every screen size, the
/// whole block is measured at a comfortable reference width and shrunk
/// uniformly to fit the box [ScaleToFit] was given.
class ScaleToFit extends StatelessWidget {
  const ScaleToFit({
    super.key,
    required this.child,
    this.referenceWidth = 560,
    this.alignment = Alignment.topCenter,
    this.fit = BoxFit.scaleDown,
  });

  final Widget child;

  /// The logical width the [child] is laid out at before scaling. Pick a
  /// width close to how the content is designed to look (comfortable
  /// reading width), not the actual screen width.
  final double referenceWidth;

  final Alignment alignment;

  /// How the reference-sized [child] is fitted into the space this widget
  /// is given. Defaults to [BoxFit.scaleDown] (shrink only, never grow).
  /// Pass [BoxFit.contain] instead when the content should also grow to
  /// use up extra room on large screens — it still preserves the child's
  /// aspect ratio (no stretching/cropping), it just no longer caps out at
  /// 1:1 scale.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit,
      alignment: alignment,
      child: SizedBox(
        width: referenceWidth,
        child: child,
      ),
    );
  }
}
