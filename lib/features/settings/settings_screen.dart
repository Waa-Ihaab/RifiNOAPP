import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 104),
          children: const [
            Text(
              'Réglages',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RifinoColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Personnalise ton expérience Rifino.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RifinoColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: RifinoSpacing.xl),
            _BlurredProfilePanel(),
            SizedBox(height: RifinoSpacing.lg),
            _SectionTitle('À propos'),
            SizedBox(height: RifinoSpacing.sm),
            _AboutCard(),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Rifino - Apprenons le Rif',
                style: TextStyle(
                  color: RifinoColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurredProfilePanel extends StatelessWidget {
  const _BlurredProfilePanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2),
          child: const IgnorePointer(
            child: _ProfilePreview(),
          ),
        ),
        const _ComingSoonBadge(),
      ],
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview();

  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.78,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: RifinoCard(
              padding: EdgeInsets.fromLTRB(18, 24, 18, 22),
              child: Column(
                children: [
                  _SettingIcon(
                    icon: Icons.person_rounded,
                    size: 86,
                    iconSize: 38,
                  ),
                  SizedBox(height: 13),
                  Text(
                    'Votre profil',
                    style: TextStyle(
                      color: RifinoColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'membre@rifino.app',
                    style: TextStyle(
                      color: RifinoColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14),
          RifinoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LockedRow(
                  icon: Icons.person_outline_rounded,
                  title: 'Modifier le profil',
                ),
                _InsetDivider(),
                _LockedRow(
                  icon: Icons.local_fire_department_rounded,
                  title: 'S\u00e9rie & objectifs',
                ),
                _InsetDivider(),
                _LockedRow(
                  icon: Icons.emoji_events_rounded,
                  title: 'R\u00e9alisations',
                ),
                _InsetDivider(),
                _LockedRow(
                  icon: Icons.cloud_rounded,
                  title: 'Synchronisation',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 238,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.92)),
            boxShadow: [
              BoxShadow(
                color: RifinoColors.primaryDark.withValues(alpha: 0.10),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SettingIcon(
                icon: Icons.lock_rounded,
                size: 56,
                iconSize: 24,
              ),
              SizedBox(height: 12),
              Text(
                'Bient\u00f4t disponible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RifinoColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Le profil et la synchronisation\narrivent bient\u00f4t.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RifinoColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: RifinoColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return RifinoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const _InfoRow(
            icon: Icons.info_rounded,
            title: 'Version',
            value: '1.0.0',
          ),
          const _InsetDivider(),
          const _InfoRow(
            icon: Icons.favorite_rounded,
            title: 'Fait pour le Rif',
          ),
          const _InsetDivider(),
          _InfoRow(
            icon: Icons.mail_rounded,
            title: 'Contact',
            value: 'contact.kariihab@gmail.com',
            multilineValue: true,
            onTap: () => launchUrl(
              Uri.parse('https://github.com/Waa-Ihaab/RifiNOAPP'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            _SettingIcon(icon: icon, color: RifinoColors.purple),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: RifinoColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: RifinoColors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    this.value,
    this.multilineValue = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? value;
  final bool multilineValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    const valueTitleWidth = 92.0;
    final titleText = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: RifinoColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );

    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: multilineValue ? 76 : 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          children: [
            _SettingIcon(icon: icon, color: RifinoColors.primary),
            const SizedBox(width: 14),

            if (value == null)
              Expanded(child: titleText)
            else
              SizedBox(width: valueTitleWidth, child: titleText),

            if (value != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: RifinoColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final onTap = this.onTap;
    if (onTap == null) return row;

    return InkWell(onTap: onTap, child: row);
  }
}
class _InsetDivider extends StatelessWidget {
  const _InsetDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 64,
      color: RifinoColors.border,
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({
    required this.icon,
    this.color = RifinoColors.primary,
    this.size = 38,
    this.iconSize = 19,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size >= 50 ? 20 : 14),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}
