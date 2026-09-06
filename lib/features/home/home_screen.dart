import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/data/dictionary_data.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/widgets/rifino_ad_banner.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:rifino/shared/widgets/rifino_logo.dart';

class RifinoHomeNotification {
  const RifinoHomeNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String id;
  final String title;
  final String body;
  final IconData icon;
}

class RifinoDailyWord {
  const RifinoDailyWord({
    required this.category,
    required this.entry,
  });

  final DictionaryCategory category;
  final DictionaryEntry entry;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenLearning,
    required this.onOpenDictionary,
    required this.onOpenWordOfDay,
    required this.onOpenNumbers,
    required this.onOpenLessons,
    required this.onOpenLesson,
    required this.wordOfDay,
    required this.notifications,
    required this.unreadNotificationCount,
    required this.onNotificationsOpened,
    required this.currentStreakDays,
    required this.activeWeekDays,
    super.key,
  });

  final VoidCallback onOpenLearning;
  final VoidCallback onOpenDictionary;
  final VoidCallback onOpenWordOfDay;
  final VoidCallback onOpenNumbers;
  final VoidCallback onOpenLessons;
  final ValueChanged<String> onOpenLesson;
  final RifinoDailyWord wordOfDay;
  final List<RifinoHomeNotification> notifications;
  final int unreadNotificationCount;
  final VoidCallback onNotificationsOpened;
  final int currentStreakDays;
  final List<bool> activeWeekDays;

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday % 7;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 104),
        children: [
          SizedBox(
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: RifinoLogo(width: 108, height: 50),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _RoundIconButton(
                    icon: Icons.notifications_none_rounded,
                    hasBadge: unreadNotificationCount > 0,
                    onTap: () => _showNotifications(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: RifinoAdBanner()),
          const SizedBox(height: RifinoSpacing.md),
          Text(
            RifinoText.tr(
              context,
              fr: 'Azul, on continue ?',
              en: 'Azul, shall we continue?',
            ),
            style: const TextStyle(
              color: RifinoColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            RifinoText.tr(
              context,
              fr: "Un petit pas aujourd'hui, ton rifain avance.",
              en: 'One small step today, your Rif keeps growing.',
            ),
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: RifinoSpacing.lg),
          _ProgressHero(
            todayIndex: todayIndex,
            activeDays: activeWeekDays,
            currentStreakDays: currentStreakDays,
            onOpenLearning: onOpenLearning,
          ),
          const SizedBox(height: RifinoSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  title: RifinoText.tr(context, fr: 'Leçons', en: 'Lessons'),
                  subtitle: RifinoText.tr(context, fr: 'Reprendre', en: 'Resume'),
                  icon: Icons.school_rounded,
                  color: RifinoColors.accentBlue,
                  onTap: onOpenLessons,
                ),
              ),
              const SizedBox(width: RifinoSpacing.sm),
              Expanded(
                child: _QuickAction(
                  title: 'Dico',
                  subtitle: RifinoText.tr(
                    context,
                    fr: '$dictionaryWordCount mots',
                    en: '$dictionaryWordCount words',
                  ),
                  icon: Icons.menu_book_rounded,
                  color: RifinoColors.accentBlue,
                  onTap: onOpenDictionary,
                ),
              ),
            ],
          ),
          const SizedBox(height: RifinoSpacing.lg),
          _FeaturedLessons(
            onOpenLessons: onOpenLessons,
            onOpenLesson: onOpenLesson,
          ),
          const SizedBox(height: RifinoSpacing.md),
          _FeaturedNumbers(onOpenNumbers: onOpenNumbers),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    onNotificationsOpened();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: RifinoColors.border,
                      borderRadius: BorderRadius.circular(RifinoRadius.pill),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  RifinoText.tr(context, fr: 'Notifications', en: 'Notifications'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                if (notifications.isEmpty)
                  const _EmptyNotifications()
                else
                  for (final notification in notifications)
                    Padding(
                      padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
                      child: _NotificationTile(notification: notification),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RifinoRadius.pill),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(RifinoRadius.pill),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: RifinoColors.textPrimary),
          ),
          if (hasBadge)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: RifinoColors.accentBlue,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(RifinoRadius.pill),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: RifinoColors.surfaceMuted,
        borderRadius: BorderRadius.circular(RifinoRadius.lg),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            color: RifinoColors.textSecondary,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            RifinoText.tr(context, fr: 'Aucune notification', en: 'No notifications'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            RifinoText.tr(
              context,
              fr: 'Tu es à jour pour le moment.',
              en: "You're all caught up for now.",
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final RifinoHomeNotification notification;

  @override
  Widget build(BuildContext context) {
    return RifinoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: RifinoColors.accentBlue.withValues(alpha: 0.14),
            child: Icon(notification.icon, color: RifinoColors.accentBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  notification.body,
                  style: const TextStyle(
                    color: RifinoColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({
    required this.todayIndex,
    required this.activeDays,
    required this.currentStreakDays,
    required this.onOpenLearning,
  });

  final int todayIndex;
  final List<bool> activeDays;
  final int currentStreakDays;
  final VoidCallback onOpenLearning;

  @override
  Widget build(BuildContext context) {
    final days = RifinoLanguageScope.isEnglish(context)
        ? const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        : const ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    final streakLabel = currentStreakDays <= 1
        ? RifinoText.tr(
            context,
            fr: '$currentStreakDays jour actif',
            en: '$currentStreakDays active day',
          )
        : RifinoText.tr(
            context,
            fr: '$currentStreakDays jours actifs',
            en: '$currentStreakDays active days',
          );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RifinoColors.primaryDark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: RifinoColors.primaryDark.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RifinoText.tr(context, fr: 'Série actuelle', en: 'Current streak'),
                      style: const TextStyle(
                        color: Color(0xFFC9D6E8),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      streakLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: onOpenLearning,
                style: FilledButton.styleFrom(
                  backgroundColor: RifinoColors.accentBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(108, 46),
                ),
                child: Text(RifinoText.tr(context, fr: 'Pratiquer', en: 'Practice')),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final active = activeDays[index];
              final isToday = index == todayIndex;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: active
                          ? isToday
                              ? RifinoColors.accentBlue
                              : Colors.white
                          : Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(14),
                      border: isToday && !active
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.32),
                            )
                          : null,
                    ),
                    child: active
                        ? Icon(
                            Icons.check_rounded,
                            color: isToday
                                ? Colors.white
                                : RifinoColors.primaryDark,
                            size: 21,
                          )
                        : null,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.72),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RifinoRadius.lg),
      child: RifinoCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 27),
            ),
            const SizedBox(height: 14),
            Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: RifinoColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedLessons extends StatelessWidget {
  const _FeaturedLessons({
    required this.onOpenLessons,
    required this.onOpenLesson,
  });

  final VoidCallback onOpenLessons;
  final ValueChanged<String> onOpenLesson;

  static const List<_FeaturedLessonData> _lessons = [
    _FeaturedLessonData(
      titleFr: 'Salutations',
      titleEn: 'Greetings',
      subtitleFr: 'Apprendre les mots de base pour saluer.',
      subtitleEn: 'Learn basic words to greet people.',
      icon: Icons.waving_hand_rounded,
      directLessonId: 'lesson-4',
    ),
    _FeaturedLessonData(
      titleFr: 'Pronoms personnels',
      titleEn: 'Personal pronouns',
      subtitleFr: 'Comprendre les bases des phrases simples.',
      subtitleEn: 'Understand the basics of simple sentences.',
      icon: Icons.record_voice_over_rounded,
      directLessonId: 'lesson-1',
    ),
    _FeaturedLessonData(
      titleFr: 'Famille',
      titleEn: 'Family',
      subtitleFr: 'Découvrir les mots liés à la famille.',
      subtitleEn: 'Discover words related to family.',
      icon: Icons.groups_rounded,
      directLessonId: 'lesson-2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: RifinoText.tr(
            context,
            fr: 'Commencer à apprendre',
            en: 'Start learning',
          ),
        ),
        const SizedBox(height: 12),
        for (final lesson in _lessons) ...[
          _FeaturedLessonRow(
            lesson: lesson,
            onTap: lesson.directLessonId == null
                ? onOpenLessons
                : () => onOpenLesson(lesson.directLessonId!),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FeaturedLessonRow extends StatelessWidget {
  const _FeaturedLessonRow({
    required this.lesson,
    required this.onTap,
  });

  final _FeaturedLessonData lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RifinoRadius.lg),
      child: RifinoCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: RifinoColors.accentBlue.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                lesson.icon,
                color: RifinoColors.accentBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  RifinoText.tr(
                    context,
                    fr: lesson.titleFr,
                    en: lesson.titleEn,
                  ),
                    style: const TextStyle(
                      color: RifinoColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                  RifinoText.tr(
                    context,
                    fr: lesson.subtitleFr,
                    en: lesson.subtitleEn,
                  ),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: RifinoColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: RifinoColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedLessonData {
  const _FeaturedLessonData({
    required this.titleFr,
    required this.titleEn,
    required this.subtitleFr,
    required this.subtitleEn,
    required this.icon,
    this.directLessonId,
  });

  final String titleFr;
  final String titleEn;
  final String subtitleFr;
  final String subtitleEn;
  final IconData icon;
  final String? directLessonId;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: RifinoColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _FeaturedNumbers extends StatelessWidget {
  const _FeaturedNumbers({required this.onOpenNumbers});

  final VoidCallback onOpenNumbers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenNumbers,
      borderRadius: BorderRadius.circular(RifinoRadius.lg),
      child: RifinoCard(
        color: RifinoColors.surfaceMuted,
        borderColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:
                      Icon(Icons.pin_rounded, color: RifinoColors.accentBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RifinoText.tr(
                          context,
                          fr: "Compter jusqu'à 5",
                          en: 'Count to 5',
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        RifinoText.tr(
                          context,
                          fr: 'Ouvre les nombres dans le dictionnaire',
                          en: 'Open numbers in the dictionary',
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: RifinoColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: RifinoColors.textSecondary),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _NumberChip(
                  fr: RifinoText.tr(context, fr: 'un', en: 'one'),
                  rif: 'wahid',
                ),
                _NumberChip(
                  fr: RifinoText.tr(context, fr: 'deux', en: 'two'),
                  rif: 'tnayen',
                ),
                _NumberChip(
                  fr: RifinoText.tr(context, fr: 'trois', en: 'three'),
                  rif: 'tratha',
                ),
                _NumberChip(
                  fr: RifinoText.tr(context, fr: 'quatre', en: 'four'),
                  rif: 'arabaa',
                ),
                _NumberChip(
                  fr: RifinoText.tr(context, fr: 'cinq', en: 'five'),
                  rif: 'khamssa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
    required this.fr,
    required this.rif,
  });

  final String fr;
  final String rif;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
        border: Border.all(color: RifinoColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fr,
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            rif,
            style: const TextStyle(
              color: RifinoColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
