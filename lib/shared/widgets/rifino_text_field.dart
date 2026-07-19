import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';

class RifinoTextField extends StatelessWidget {
  const RifinoTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: RifinoColors.textSecondary,
              ),
        ),
        const SizedBox(height: RifinoSpacing.xs),
        SizedBox(
          height: RifinoControlSize.inputHeight,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(hintText: hint),
          ),
        ),
      ],
    );
  }
}

