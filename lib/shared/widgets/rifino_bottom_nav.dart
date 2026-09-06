import 'package:flutter/material.dart';
import 'package:rifino/app/app_route.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/shared/localization/rifino_language.dart';

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
      labelKey: _RifinoTabLabel.home,
    ),
    _RifinoTab(
      route: AppRoute.learning,
      icon: Icons.school_rounded,
      labelKey: _RifinoTabLabel.learning,
    ),
    _RifinoTab(
      route: AppRoute.saved,
      icon: Icons.bookmark_rounded,
      labelKey: _RifinoTabLabel.saved,
    ),
    _RifinoTab(
      route: AppRoute.settings,
      icon: Icons.settings_rounded,
      labelKey: _RifinoTabLabel.settings,
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
                  label: _labelFor(context, tab.labelKey),
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

  String _labelFor(BuildContext context, _RifinoTabLabel labelKey) {
    return switch (labelKey) {
      _RifinoTabLabel.home => RifinoText.home(context),
      _RifinoTabLabel.learning => RifinoText.learning(context),
      _RifinoTabLabel.saved => RifinoText.saved(context),
      _RifinoTabLabel.settings => RifinoText.settings(context),
    };
  }
}

class _RifinoTabButton extends StatelessWidget {
  const _RifinoTabButton({
    required this.tab,
    required this.active,
    required this.label,
    required this.onTap,
  });

  final _RifinoTab tab;
  final bool active;
  final String label;
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
                  label,
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
    required this.labelKey,
  });

  final AppRoute route;
  final IconData icon;
  final _RifinoTabLabel labelKey;
}

enum _RifinoTabLabel {
  home,
  learning,
  saved,
  settings,
}
