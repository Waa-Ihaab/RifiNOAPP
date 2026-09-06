import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/data/lesson_data.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/models/saved_entry.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:rifino/shared/widgets/rifino_top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({
    required this.onBack,
    required this.savedIds,
    required this.onToggleSaved,
    required this.onLessonCompleted,
    this.initialLessonId,
    this.openInitialLesson = false,
    super.key,
  });

  final VoidCallback onBack;
  final Set<String> savedIds;
  final ValueChanged<SavedEntry> onToggleSaved;
  final VoidCallback onLessonCompleted;
  final String? initialLessonId;
  final bool openInitialLesson;

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  static const _completedLessonsKey = 'rifino.lessons.completed';

  String? _activeLessonId = rifinoLessons.first.id;
  RifinoLesson? _openedLesson;
  final Set<String> _completedLessonIds = {
    for (final lesson in rifinoLessons)
      if (lesson.finished) lesson.id,
  };

  @override
  void initState() {
    super.initState();
    final initialLesson = _findInitialLesson();
    if (initialLesson != null) {
      _activeLessonId = initialLesson.id;
      if (widget.openInitialLesson) _openedLesson = initialLesson;
    }
    _loadCompletedLessons();
  }

  RifinoLesson? _findInitialLesson() {
    final initialLessonId = widget.initialLessonId;
    if (initialLessonId == null) return null;

    for (final lesson in rifinoLessons) {
      if (lesson.id == initialLessonId) return lesson;
    }
    return null;
  }

  Future<void> _loadCompletedLessons() async {
    final preferences = await SharedPreferences.getInstance();
    final completedIds = preferences.getStringList(_completedLessonsKey) ?? [];

    if (!mounted) return;
    setState(() {
      _completedLessonIds.addAll(completedIds);
    });
  }

  Future<void> _saveCompletedLessons() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _completedLessonsKey,
      _completedLessonIds.toList()..sort(),
    );
  }

  void _completeLesson(RifinoLesson lesson) {
    setState(() {
      _completedLessonIds.add(lesson.id);
      _openedLesson = null;
      _activeLessonId = lesson.id;
    });
    _saveCompletedLessons();
    widget.onLessonCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final openedLesson = _openedLesson;
    if (openedLesson != null) {
      return _LessonDetailView(
        lesson: openedLesson,
        saved: widget.savedIds.contains(_lessonSavedId(openedLesson)),
        savedIds: widget.savedIds,
        onBack: () => setState(() => _openedLesson = null),
        onToggleSaved: widget.onToggleSaved,
        onComplete: () => _completeLesson(openedLesson),
      );
    }

    final finishedCount = rifinoLessons
        .where((lesson) => _completedLessonIds.contains(lesson.id))
        .length;
    final progress = finishedCount / rifinoLessons.length;

    return Scaffold(
      appBar: RifinoTopBar(
        title: RifinoText.tr(context, fr: 'Leçons', en: 'Lessons'),
        onBack: widget.onBack,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 96),
        children: [
          _LessonsProgressHeader(
            finishedCount: finishedCount,
            totalCount: rifinoLessons.length,
            progress: progress,
          ),
          const SizedBox(height: RifinoSpacing.lg),
          Text(
            RifinoText.tr(context, fr: 'Parcours', en: 'Path'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            RifinoText.tr(
              context,
              fr: 'Avance leçon par leçon et valide ce que tu as appris.',
              en: 'Move lesson by lesson and validate what you learned.',
            ),
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: RifinoSpacing.md),
          for (var i = 0; i < rifinoLessons.length; i++)
            _LessonCard(
              index: i,
              lesson: rifinoLessons[i],
              active: rifinoLessons[i].id == _activeLessonId,
              completed: _completedLessonIds.contains(rifinoLessons[i].id),
              saved: widget.savedIds.contains(_lessonSavedId(rifinoLessons[i])),
              onTap: () {
                setState(() {
                  _activeLessonId = rifinoLessons[i].id == _activeLessonId
                      ? null
                      : rifinoLessons[i].id;
                });
              },
              onOpen: () => setState(() => _openedLesson = rifinoLessons[i]),
              onToggleSaved: () {
                widget.onToggleSaved(
                  SavedEntry(
                    id: _lessonSavedId(rifinoLessons[i]),
                    kind: SavedEntryKind.lesson,
                    title: RifinoText.lessonTitle(
                      context,
                      rifinoLessons[i].id,
                      rifinoLessons[i].title,
                    ),
                    subtitle:
                        '${RifinoText.lessonLevel(context, rifinoLessons[i].level)} - ${RifinoText.lessonDescription(context, rifinoLessons[i].id, rifinoLessons[i].description)}',
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _LessonsProgressHeader extends StatelessWidget {
  const _LessonsProgressHeader({
    required this.finishedCount,
    required this.totalCount,
    required this.progress,
  });

  final int finishedCount;
  final int totalCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [RifinoColors.primary, Color(0xFF0A4B94)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: RifinoColors.primary.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                RifinoText.tr(context, fr: 'Mes leçons', en: 'My lessons'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  RifinoText.tr(
                    context,
                    fr: '$finishedCount/$totalCount finies',
                    en: '$finishedCount/$totalCount done',
                  ),
                  style: const TextStyle(
                    color: RifinoColors.accentBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(RifinoRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              color: RifinoColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            RifinoText.tr(
              context,
              fr: '$percent% complété',
              en: '$percent% complete',
            ),
            style: const TextStyle(
              color: Color(0xFFDCE8F7),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.index,
    required this.lesson,
    required this.active,
    required this.completed,
    required this.saved,
    required this.onTap,
    required this.onOpen,
    required this.onToggleSaved,
  });

  final int index;
  final RifinoLesson lesson;
  final bool active;
  final bool completed;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onOpen;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? RifinoColors.success
        : active
            ? RifinoColors.accentBlue
            : RifinoColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RifinoRadius.md),
        child: RifinoCard(
          padding: EdgeInsets.zero,
          borderColor: active ? color.withValues(alpha: 0.45) : RifinoColors.border,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: completed
                            ? Icon(Icons.check_rounded, color: color, size: 24)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  RifinoText.lessonLevel(context, lesson.level),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              if (completed) ...[
                                const SizedBox(width: 8),
                                const _CompletedBadge(),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            RifinoText.lessonTitle(context, lesson.id, lesson.title),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            RifinoText.lessonDescription(
                              context,
                              lesson.id,
                              lesson.description,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: RifinoColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: saved
                          ? RifinoText.tr(context, fr: 'Retirer', en: 'Remove')
                          : RifinoText.tr(context, fr: 'Enregistrer', en: 'Save'),
                      onPressed: onToggleSaved,
                      icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                      color: saved ? RifinoColors.accentBlue : RifinoColors.purple,
                    ),
                    Icon(
                      active
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: RifinoColors.textSecondary,
                      size: 28,
                    ),
                  ],
                ),
              ),
              if (active) ...[
                const Divider(height: 1, color: RifinoColors.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final word in lesson.vocabulary)
                              _VocabularyChip(
                                text:
                                    '${word.rif} - ${RifinoText.word(context, word.fr)}',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: FilledButton.icon(
                          onPressed: onOpen,
                          icon: Icon(
                            completed
                                ? Icons.replay_rounded
                                : Icons.play_arrow_rounded,
                            size: 20,
                          ),
                          label: Text(
                            completed
                                ? RifinoText.tr(
                                    context,
                                    fr: 'Revoir le cours',
                                    en: 'Review the course',
                                  )
                                : RifinoText.tr(
                                    context,
                                    fr: 'Entrer dans le cours',
                                    en: 'Enter the course',
                                  ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                completed ? RifinoColors.accentBlue : RifinoColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(RifinoRadius.sm),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: RifinoColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
      ),
      child: Text(
        RifinoText.tr(context, fr: 'Fini', en: 'Done'),
        style: const TextStyle(
          color: RifinoColors.success,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _VocabularyChip extends StatelessWidget {
  const _VocabularyChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: RifinoColors.surfaceMuted,
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _LessonDetailView extends StatelessWidget {
  const _LessonDetailView({
    required this.lesson,
    required this.saved,
    required this.savedIds,
    required this.onBack,
    required this.onToggleSaved,
    required this.onComplete,
  });

  final RifinoLesson lesson;
  final bool saved;
  final Set<String> savedIds;
  final VoidCallback onBack;
  final ValueChanged<SavedEntry> onToggleSaved;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final lessonColor = _lessonAccentColor(lesson);

    return Scaffold(
      backgroundColor: const Color(0xFFF1FBFD),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                _SoftIconButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: onBack,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    RifinoText.lessonTitle(context, lesson.id, lesson.title),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: RifinoColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _SoftIconButton(
                  icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: saved ? RifinoColors.accentBlue : RifinoColors.primary,
                  onPressed: () => onToggleSaved(_lessonSavedEntry(context, lesson)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: lessonColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: lessonColor.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(_lessonIcon(lesson), color: Colors.white, size: 34),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _LessonPill(
                text: RifinoText.lessonLevel(context, lesson.level),
                color: lessonColor,
              ),
              const SizedBox(width: 8),
              _LessonPill(
                text: RifinoText.tr(
                  context,
                  fr: '${lesson.vocabulary.length} mots',
                  en: '${lesson.vocabulary.length} words',
                ),
                color: lessonColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              RifinoText.lessonDescription(context, lesson.id, lesson.description),
              style: const TextStyle(
                color: RifinoColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _DetailTitle(RifinoText.tr(context, fr: 'Vocabulaire', en: 'Vocabulary')),
          const SizedBox(height: RifinoSpacing.sm),
          for (final word in lesson.vocabulary)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _VocabularyRow(
                lesson: lesson,
                word: word,
                saved: savedIds.contains(_vocabularySavedId(lesson, word)),
                onToggleSaved: onToggleSaved,
              ),
            ),
          const SizedBox(height: RifinoSpacing.md),
          _DetailTitle(RifinoText.tr(context, fr: 'Cours', en: 'Course')),
          const SizedBox(height: RifinoSpacing.sm),
          for (final paragraph
              in RifinoText.lessonContent(context, lesson.id, lesson.content))
            Padding(
              padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
              child: _LessonTextCard(text: paragraph),
            ),
          const SizedBox(height: RifinoSpacing.md),
          _DetailTitle(RifinoText.tr(context, fr: 'Exemples', en: 'Examples')),
          const SizedBox(height: RifinoSpacing.sm),
          for (final example
              in RifinoText.lessonExamples(context, lesson.id, lesson.examples))
            Padding(
              padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
              child: _ExampleRow(text: example),
            ),
          const SizedBox(height: RifinoSpacing.lg),
          FilledButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(RifinoText.tr(context, fr: 'Terminer', en: 'Finish')),
            style: FilledButton.styleFrom(backgroundColor: RifinoColors.success),
          ),
        ],
      ),
    );
  }
}

class _SoftIconButton extends StatelessWidget {
  const _SoftIconButton({
    required this.icon,
    required this.onPressed,
    this.color = RifinoColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 27),
        tooltip: '',
      ),
    );
  }
}

class _LessonPill extends StatelessWidget {
  const _LessonPill({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DetailTitle extends StatelessWidget {
  const _DetailTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
    );
  }
}

class _LessonTextCard extends StatelessWidget {
  const _LessonTextCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RifinoColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: RifinoColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
      ),
    );
  }
}

class _VocabularyRow extends StatelessWidget {
  const _VocabularyRow({
    required this.lesson,
    required this.word,
    required this.saved,
    required this.onToggleSaved,
  });

  final RifinoLesson lesson;
  final RifinoVocabularyWord word;
  final bool saved;
  final ValueChanged<SavedEntry> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.rif,
                  style: const TextStyle(
                    color: RifinoColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  RifinoText.word(context, word.fr),
                  style: const TextStyle(
                    color: RifinoColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  word.pronunciation,
                  style: const TextStyle(
                    color: RifinoColors.accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          _TinyCircleButton(
            icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: saved ? RifinoColors.accentBlue : RifinoColors.textSecondary,
            onPressed: () => onToggleSaved(_vocabularySavedEntry(context, lesson, word)),
          ),
        ],
      ),
    );
  }
}

class _TinyCircleButton extends StatelessWidget {
  const _TinyCircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        padding: EdgeInsets.zero,
        tooltip: '',
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: RifinoColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded, color: RifinoColors.accentBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

String _lessonSavedId(RifinoLesson lesson) {
  return 'lesson:${lesson.id}';
}

String _vocabularySavedId(RifinoLesson lesson, RifinoVocabularyWord word) {
  return 'lesson-word:${lesson.id}:${word.rif}:${word.fr}';
}

SavedEntry _lessonSavedEntry(BuildContext context, RifinoLesson lesson) {
  return SavedEntry(
    id: _lessonSavedId(lesson),
    kind: SavedEntryKind.lesson,
    title: RifinoText.lessonTitle(context, lesson.id, lesson.title),
    subtitle:
        '${RifinoText.lessonLevel(context, lesson.level)} - ${RifinoText.lessonDescription(context, lesson.id, lesson.description)}',
  );
}

SavedEntry _vocabularySavedEntry(
  BuildContext context,
  RifinoLesson lesson,
  RifinoVocabularyWord word,
) {
  return SavedEntry(
    id: _vocabularySavedId(lesson, word),
    kind: SavedEntryKind.word,
    title: word.rif,
    subtitle:
        '${RifinoText.word(context, word.fr)} - ${RifinoText.lessonTitle(context, lesson.id, lesson.title)}',
  );
}

IconData _lessonIcon(RifinoLesson lesson) {
  return switch (lesson.id) {
    'lesson-1' => Icons.record_voice_over_rounded,
    'lesson-2' => Icons.family_restroom_rounded,
    'lesson-5' => Icons.tag_rounded,
    _ => Icons.school_rounded,
  };
}

Color _lessonAccentColor(RifinoLesson lesson) {
  return switch (lesson.id) {
    'lesson-1' => RifinoColors.purple,
    'lesson-2' => RifinoColors.success,
    'lesson-5' => const Color(0xFF1798B8),
    _ => RifinoColors.accentBlue,
  };
}
