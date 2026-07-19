import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({
    required this.onOpenAudio,
    required this.onOpenDictionary,
    required this.onOpenQuiz,
    required this.onOpenLessons,
    super.key,
  });

  final VoidCallback onOpenAudio;
  final VoidCallback onOpenDictionary;
  final VoidCallback onOpenQuiz;
  final VoidCallback onOpenLessons;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 104),
        children: [
          const Text(
            'Apprendre',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          const Text(
            'Choisis ton mode et garde ton rythme.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RifinoColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: RifinoSpacing.xl),
          _FeaturedLesson(onTap: onOpenLessons),
          const SizedBox(height: RifinoSpacing.lg),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: RifinoSpacing.sm,
            mainAxisSpacing: RifinoSpacing.sm,
            childAspectRatio: 0.96,
            children: [
              _LearningTile(
                title: 'Audio',
                subtitle: 'Écoute et répète',
                icon: Icons.volume_up_rounded,
                color: RifinoColors.accentBlue,
                onTap: onOpenAudio,
              ),
              _LearningTile(
                title: 'Dico',
                subtitle: 'Mots utiles',
                icon: Icons.menu_book_rounded,
                color: RifinoColors.purple,
                onTap: onOpenDictionary,
              ),
              _LearningTile(
                title: 'Quiz',
                subtitle: 'Teste-toi',
                icon: Icons.check_circle_rounded,
                color: RifinoColors.accent,
                onTap: onOpenQuiz,
              ),
              _LearningTile(
                title: 'Leçons',
                subtitle: 'Cours guidés',
                icon: Icons.school_rounded,
                color: RifinoColors.coral,
                onTap: onOpenLessons,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturedLesson extends StatelessWidget {
  const _FeaturedLesson({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: RifinoColors.primaryDark,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: RifinoColors.primaryDark.withValues(alpha: 0.20),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Continue la leçon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pronoms personnels - 5 min',
                    style: TextStyle(
                      color: Color(0xFFC9D6E8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _LearningTile extends StatelessWidget {
  const _LearningTile({
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
        borderColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: RifinoColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
