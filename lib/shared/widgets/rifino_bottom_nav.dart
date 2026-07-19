import 'package:flutter/material.dart';
import 'package:rifino/app/app_route.dart';
import 'package:rifino/core/theme/rifino_colors.dart';

class RifinoBottomNav extends StatelessWidget {
  const RifinoBottomNav({
    required this.currentRoute,
    required this.onSelected,
    super.key,
  });

  final AppRoute currentRoute;
  final ValueChanged<AppRoute> onSelected;

  static const _tabs = [
    _RifinoTab(
      route: AppRoute.home,
      icon: Icons.home_rounded,
      label: 'Accueil',
    ),
    _RifinoTab(
      route: AppRoute.learning,
      icon: Icons.school_rounded,
      label: 'Apprendre',
    ),
    _RifinoTab(
      route: AppRoute.saved,
      icon: Icons.bookmark_rounded,
      label: 'Enregistr\u00e9s',
    ),
    _RifinoTab(
      route: AppRoute.settings,
      icon: Icons.settings_rounded,
      label: 'R\u00e9glages',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF8F8),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: RifinoColors.primaryDark.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            for (final tab in _tabs)
              Expanded(
                child: _RifinoTabButton(
                  tab: tab,
                  active: _isActive(tab.route),
                  onTap: () => onSelected(tab.route),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isActive(AppRoute route) {
    return switch (currentRoute) {
      AppRoute.home => route == AppRoute.home,
      AppRoute.learning ||
      AppRoute.dictionary ||
      AppRoute.lessons ||
      AppRoute.audio ||
      AppRoute.quiz =>
        route == AppRoute.learning,
      AppRoute.saved => route == AppRoute.saved,
      AppRoute.settings => route == AppRoute.settings,
    };
  }
}

class _RifinoTabButton extends StatelessWidget {
  const _RifinoTabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final _RifinoTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? RifinoColors.accentBlue : RifinoColors.primaryDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: active ? 62 : 42,
              height: active ? 48 : 42,
              decoration: BoxDecoration(
                color: active
                    ? RifinoColors.accentBlue.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tab.icon, color: color, size: 23),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.5,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RifinoTab {
  const _RifinoTab({
    required this.route,
    required this.icon,
    required this.label,
  });

  final AppRoute route;
  final IconData icon;
  final String label;
}
