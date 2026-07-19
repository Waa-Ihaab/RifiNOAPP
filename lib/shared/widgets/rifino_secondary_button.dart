import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';

class RifinoSecondaryButton extends StatelessWidget {
  const RifinoSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: RifinoControlSize.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.add_rounded),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: RifinoColors.primary,
          side: const BorderSide(color: RifinoColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RifinoRadius.md),
          ),
        ),
      ),
    );
  }
}

