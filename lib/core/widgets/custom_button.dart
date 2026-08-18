import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;
  final bool isFullWidth;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.height = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveTextColor = textColor ?? (isOutlined ? effectiveColor : Colors.white);

    final buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: effectiveTextColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: isOutlined ? BorderSide(color: effectiveColor, width: 1.8) : BorderSide.none,
    );

    Widget button;
    if (isOutlined) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: shape,
          minimumSize: Size(isFullWidth ? double.infinity : 100, height),
        ),
        child: buttonChild,
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveColor,
          shape: shape,
          elevation: 2,
          minimumSize: Size(isFullWidth ? double.infinity : 100, height),
        ),
        child: buttonChild,
      );
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
