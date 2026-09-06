import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/widgets/rifino_ad_banner.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.languageCode,
    required this.onLanguageChanged,
    super.key,
  });

  final String languageCode;
  final ValueChanged<String> onLanguageChanged;

  Future<void> _showLanguagePicker(BuildContext context) async {
    final selectedLanguage = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LanguagePickerSheet(selectedLanguageCode: languageCode);
      },
    );

    if (selectedLanguage == null) return;
    onLanguageChanged(selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 104),
          children: [
            const Center(child: RifinoAdBanner()),
            const SizedBox(height: RifinoSpacing.md),
            Text(
              RifinoText.settingsTitle(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: RifinoColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              RifinoText.settingsSubtitle(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: RifinoColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: RifinoSpacing.xl),
            const _LockedProfileSection(),
            const SizedBox(height: RifinoSpacing.lg),
            _LanguageCard(
              languageCode: languageCode,
              onTap: () => _showLanguagePicker(context),
            ),
            const SizedBox(height: RifinoSpacing.lg),
            _SectionTitle(RifinoText.about(context)),
            const SizedBox(height: RifinoSpacing.sm),
            const _AboutCard(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                RifinoText.footer(context),
                style: const TextStyle(
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

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.languageCode,
    required this.onTap,
  });

  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final language = _RifinoLanguage.fromCode(languageCode);

    return RifinoCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RifinoRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              const _SettingIcon(icon: Icons.translate_rounded),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  RifinoText.language(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RifinoColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _LanguageBadge(language: language),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: RifinoColors.textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedProfileSection extends StatelessWidget {
  const _LockedProfileSection();

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
    return Opacity(
      opacity: 0.78,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: RifinoCard(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 43,
                    backgroundColor: Color(0xFFEAF2FF),
                    child: Icon(
                      Icons.person_rounded,
                      color: RifinoColors.primary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    RifinoText.tr(
                      context,
                      fr: 'Votre profil',
                      en: 'Your profile',
                    ),
                    style: const TextStyle(
                      color: RifinoColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
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
          const SizedBox(height: 14),
          RifinoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LockedRow(
                  icon: Icons.person_outline_rounded,
                  title: RifinoText.tr(
                    context,
                    fr: 'Modifier le profil',
                    en: 'Edit profile',
                  ),
                ),
                const _InsetDivider(),
                _LockedRow(
                  icon: Icons.local_fire_department_rounded,
                  title: RifinoText.tr(
                    context,
                    fr: 'Série & objectifs',
                    en: 'Streak & goals',
                  ),
                ),
                const _InsetDivider(),
                _LockedRow(
                  icon: Icons.emoji_events_rounded,
                  title: RifinoText.tr(
                    context,
                    fr: 'Réalisations',
                    en: 'Achievements',
                  ),
                ),
                const _InsetDivider(),
                _LockedRow(
                  icon: Icons.cloud_rounded,
                  title: RifinoText.tr(
                    context,
                    fr: 'Synchronisation',
                    en: 'Sync',
                  ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFEAF2FF),
                child: Icon(
                  Icons.lock_rounded,
                  color: RifinoColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                RifinoText.tr(
                  context,
                  fr: 'Bientôt disponible',
                  en: 'Coming soon',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: RifinoColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                RifinoText.tr(
                  context,
                  fr: 'Créez votre profil bientôt!.',
                  en: 'Create your profile soon!',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
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

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({required this.selectedLanguageCode});

  final String selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: RifinoColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: RifinoColors.primaryDark.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                width: 42,
                child: Divider(
                  thickness: 4,
                  color: RifinoColors.border,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              RifinoText.appLanguage(context),
              style: const TextStyle(
                color: RifinoColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            for (final language in _RifinoLanguage.values)
              _LanguageOptionTile(
                language: language,
                selected: selectedLanguageCode == language.code,
                onTap: () => Navigator.of(context).pop(language.code),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final _RifinoLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? RifinoColors.accentBlue.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? RifinoColors.accentBlue : RifinoColors.border,
            ),
          ),
          child: Row(
            children: [
              Text(
                language.flag,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language.name,
                  style: const TextStyle(
                    color: RifinoColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                language.code.toUpperCase(),
                style: const TextStyle(
                  color: RifinoColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? RifinoColors.accentBlue : RifinoColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  const _LanguageBadge({required this.language});

  final _RifinoLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          language.code.toUpperCase(),
          style: const TextStyle(
            color: RifinoColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _RifinoLanguage {
  const _RifinoLanguage({
    required this.code,
    required this.name,
    required this.flag,
  });

  final String code;
  final String name;
  final String flag;

  static const values = [
    _RifinoLanguage(code: 'fr', name: 'Français', flag: '\u{1F1EB}\u{1F1F7}'),
    _RifinoLanguage(code: 'en', name: 'English', flag: '\u{1F1EC}\u{1F1E7}'),
  ];

  static _RifinoLanguage fromCode(String code) {
    return values.firstWhere(
      (language) => language.code == code,
      orElse: () => values.first,
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
            value: '1.0.1',
          ),
          const _InsetDivider(),
          _InfoRow(
            icon: Icons.favorite_rounded,
            title: RifinoText.madeForRif(context),
          ),
          const _InsetDivider(),
          _InfoRow(
            icon: Icons.mail_rounded,
            title: 'Contact',
            value: 'contact.kariihab@gmail.com',
            multilineValue: true,
            onTap: () => launchUrl(
              Uri.parse('https://waa-ihaab.github.io/rifino-support/'),
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
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    const iconSize = 19.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}
