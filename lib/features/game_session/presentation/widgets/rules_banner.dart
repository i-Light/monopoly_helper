import 'package:flutter/material.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/utils/responsive.dart';

/// A single-line "rules" summary for the current challenge that expands
/// into a floating card (like a tooltip) instead of pushing the rest of
/// the page down, so the layout around it never shifts. This is the only
/// place the challenge's rules text is shown.
class RulesBanner extends StatefulWidget {
  const RulesBanner({super.key, required this.rules});

  final String rules;

  @override
  State<RulesBanner> createState() => _RulesBannerState();
}

class _RulesBannerState extends State<RulesBanner> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  bool _isExpanded = false;

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
  }

  void _close() {
    setState(() => _isExpanded = false);
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return Stack(
            children: [
              // Full-screen transparent barrier so tapping anywhere else closes it.
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _close,
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomCenter,
                followerAnchor: Alignment.topCenter,
                offset: const Offset(0, 6),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(14 * scale),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.info.withValues(alpha: 0.5)),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: AppColors.info, size: 18 * scale),
                          SizedBox(width: 10 * scale),
                          Expanded(
                            child: Text(
                              widget.rules,
                              style: TextStyle(fontSize: 13 * scale, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 10 * scale),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 18 * scale),
                  SizedBox(width: 10 * scale),
                  Expanded(
                    child: Text(
                      '${AppStrings.rulesBannerPrefix}: ${widget.rules}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12 * scale, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 6 * scale),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18 * scale,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
