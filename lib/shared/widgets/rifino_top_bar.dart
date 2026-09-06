import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/widgets/rifino_ad_banner.dart';

class RifinoTopBar extends StatelessWidget implements PreferredSizeWidget {
  const RifinoTopBar({
    required this.title,
    this.onBack,
    this.showAd = true,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showAd;

  @override
  Size get preferredSize => Size.fromHeight(showAd ? 116 : 62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAd) ...[
            const Center(child: RifinoAdBanner()),
            const SizedBox(height: 4),
          ],
          SizedBox(
            height: 58,
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: onBack == null
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: onBack,
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(RifinoRadius.pill),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              size: 28,
                            ),
                          ),
                        ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: RifinoColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 56),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: RifinoColors.background,
      surfaceTintColor: RifinoColors.background,
      foregroundColor: RifinoColors.textPrimary,
    );
  }
}
