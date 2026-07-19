import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';

class RifinoTopBar extends StatelessWidget implements PreferredSizeWidget {
  const RifinoTopBar({
    required this.title,
    this.onBack,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack == null
          ? const SizedBox(width: 44)
          : IconButton(
              onPressed: onBack,
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(RifinoRadius.pill),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.chevron_left_rounded, size: 28),
              ),
            ),
      title: Text(title),
      centerTitle: true,
      backgroundColor: RifinoColors.background,
      surfaceTintColor: RifinoColors.background,
      foregroundColor: RifinoColors.textPrimary,
      titleTextStyle: const TextStyle(
        color: RifinoColors.textPrimary,
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
