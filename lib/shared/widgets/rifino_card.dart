import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';

class RifinoCard extends StatelessWidget {
  const RifinoCard({
    required this.child,
    this.padding = const EdgeInsets.all(RifinoSpacing.md),
    this.color = RifinoColors.surface,
    this.borderColor = RifinoColors.border,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RifinoRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172033).withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
