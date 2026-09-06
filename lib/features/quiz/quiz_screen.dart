import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/data/dictionary_data.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:rifino/shared/widgets/rifino_top_bar.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    required this.onBack,
    required this.onCompleted,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onCompleted;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.prompt,
    required this.answer,
    required this.options,
  });

  final String prompt;
  final String answer;
  final List<String> options;
}

class _QuizAnswer {
  const _QuizAnswer({
    required this.question,
    required this.selectedAnswer,
  });

  final _QuizQuestion question;
  final String selectedAnswer;

  bool get isCorrect => selectedAnswer == question.answer;
}

class _QuizScreenState extends State<QuizScreen> {
  late List<_QuizQuestion> _questions;
  final List<_QuizAnswer> _answers = [];
  int _index = 0;
  String? _selected;
  bool _finished = false;

  _QuizQuestion get _currentQuestion => _questions[_index];

  @override
  void initState() {
    super.initState();
    _restart();
  }

  void _restart() {
    setState(() {
      _questions = _buildQuestions();
      _answers.clear();
      _index = 0;
      _selected = null;
      _finished = false;
    });
  }

  void _submitAnswer() {
    final selected = _selected;
    if (selected == null) return;

    _answers.add(
      _QuizAnswer(
        question: _currentQuestion,
        selectedAnswer: selected,
      ),
    );

    if (_index == _questions.length - 1) {
      widget.onCompleted();
      setState(() => _finished = true);
      return;
    }

    setState(() {
      _index++;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _finished ? 1.0 : (_index + (_selected == null ? 0 : 1)) / _questions.length;

    return Scaffold(
      appBar: RifinoTopBar(title: 'Quiz', onBack: widget.onBack),
      body: SafeArea(
        top: false,
        child: _finished
            ? _ResultView(
                answers: List.unmodifiable(_answers),
                onRestart: _restart,
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          RifinoText.tr(
                            context,
                            fr: 'Question ${_index + 1}/${_questions.length}',
                            en: 'Question ${_index + 1}/${_questions.length}',
                          ),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: RifinoColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE6EAF2),
                        color: RifinoColors.accentBlue,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: _QuestionCard(
                            question: _currentQuestion,
                            selected: _selected,
                            onSelected: (value) => setState(() => _selected = value),
                            onSubmit: _submitAnswer,
                            isLastQuestion: _index == _questions.length - 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selected,
    required this.onSelected,
    required this.onSubmit,
    required this.isLastQuestion,
  });

  final _QuizQuestion question;
  final String? selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onSubmit;
  final bool isLastQuestion;

  @override
  Widget build(BuildContext context) {
    return RifinoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            RifinoText.tr(context, fr: 'Traduis en rifain', en: 'Translate into Rif'),
            style: const TextStyle(
              color: RifinoColors.purple,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: RifinoSpacing.md),
          Text(
            RifinoText.tr(context, fr: 'Que veut dire', en: 'What does this mean?'),
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              RifinoText.word(context, question.prompt),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: RifinoColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 24),
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _AnswerOption(
                label: option,
                selected: selected == option,
                onTap: () => onSelected(option),
              ),
            ),
          const SizedBox(height: RifinoSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: selected == null ? null : onSubmit,
              icon: Icon(isLastQuestion ? Icons.done_all_rounded : Icons.arrow_forward_rounded),
              label: Text(
                isLastQuestion
                    ? RifinoText.tr(context, fr: 'Terminer le quiz', en: 'Finish quiz')
                    : RifinoText.tr(context, fr: 'Question suivante', en: 'Next question'),
              ),
              style: FilledButton.styleFrom(backgroundColor: RifinoColors.accentBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? RifinoColors.accentBlue.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? RifinoColors.accentBlue : RifinoColors.border,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? RifinoColors.accentBlue : RifinoColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: RifinoColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.answers,
    required this.onRestart,
  });

  final List<_QuizAnswer> answers;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final score = answers.where((answer) => answer.isCorrect).length;
    final total = answers.length;
    final percent = total == 0 ? 0 : (score / total * 100).round();
    final color = percent >= 80
        ? RifinoColors.success
        : percent >= 50
            ? RifinoColors.warning
            : RifinoColors.danger;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        RifinoCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 136,
                height: 136,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 136,
                      height: 136,
                      child: CircularProgressIndicator(
                        value: total == 0 ? 0 : score / total,
                        strokeWidth: 11,
                        backgroundColor: const Color(0xFFE6EAF2),
                        color: color,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$score/$total',
                          style: TextStyle(
                            color: color,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            color: RifinoColors.textSecondary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _resultTitle(context, percent),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                RifinoText.tr(
                  context,
                  fr: 'Voici ta correction détaillée.',
                  en: 'Here is your detailed correction.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: RifinoColors.textSecondary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(RifinoText.tr(context, fr: 'Recommencer', en: 'Restart')),
                style: FilledButton.styleFrom(backgroundColor: RifinoColors.accentBlue),
              ),
            ],
          ),
        ),
        const SizedBox(height: RifinoSpacing.lg),
        Text(
          RifinoText.tr(context, fr: 'Correction', en: 'Correction'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: RifinoSpacing.md),
        for (var index = 0; index < answers.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
            child: _CorrectionRow(
              index: index + 1,
              answer: answers[index],
            ),
          ),
      ],
    );
  }

  String _resultTitle(BuildContext context, int percent) {
    if (percent >= 80) {
      return RifinoText.tr(context, fr: 'Très bonne note', en: 'Great score');
    }
    if (percent >= 50) {
      return RifinoText.tr(context, fr: 'Pas mal, continue', en: 'Not bad, keep going');
    }
    return RifinoText.tr(
      context,
      fr: 'À revoir tranquillement',
      en: 'Review this calmly',
    );
  }
}

class _CorrectionRow extends StatelessWidget {
  const _CorrectionRow({
    required this.index,
    required this.answer,
  });

  final int index;
  final _QuizAnswer answer;

  @override
  Widget build(BuildContext context) {
    final color = answer.isCorrect ? RifinoColors.success : RifinoColors.danger;

    return RifinoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Icon(
              answer.isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ${RifinoText.word(context, answer.question.prompt)}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                Text(
                  RifinoText.tr(
                    context,
                    fr: 'Ta réponse: ${answer.selectedAnswer}',
                    en: 'Your answer: ${answer.selectedAnswer}',
                  ),
                  style: const TextStyle(
                    color: RifinoColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  RifinoText.tr(
                    context,
                    fr: 'Correction: ${answer.question.answer}',
                    en: 'Correction: ${answer.question.answer}',
                  ),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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

List<_QuizQuestion> _buildQuestions() {
  final random = Random();
  final entries = dictionaryCategories.expand((item) => item.entries).toList()..shuffle(random);
  final allAnswers = entries.map((entry) => entry.rif).toSet().toList();

  return entries.take(10).map((entry) {
    final wrongAnswers = allAnswers.where((answer) => answer != entry.rif).toList()..shuffle(random);
    final options = <String>[entry.rif, ...wrongAnswers.take(3)]..shuffle(random);

    return _QuizQuestion(
      prompt: entry.fr,
      answer: entry.rif,
      options: options,
    );
  }).toList();
}
