import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/widgets/rifino_logo.dart';
import 'package:rifino/shared/widgets/rifino_primary_button.dart';

class OnboardingProfile {
  const OnboardingProfile({
    required this.source,
    required this.level,
    required this.reason,
    required this.goal,
    required this.notificationsEnabled,
  });

  final String source;
  final String level;
  final String reason;
  final String goal;
  final bool notificationsEnabled;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.onComplete,
    super.key,
  });

  final Future<void> Function(OnboardingProfile profile) onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _notificationChannel = MethodChannel('rifino/notifications');

  static const _sourceOptions = [
    _OnboardingOption('Facebook', 'Facebook', Icons.facebook),
    _OnboardingOption('TikTok', 'TikTok', Icons.music_note_rounded),
    _OnboardingOption('Instagram', 'Instagram', Icons.camera_alt_outlined),
    _OnboardingOption('Google', 'Google', Icons.search_rounded),
    _OnboardingOption('App Store', 'App Store', Icons.apps_rounded),
    _OnboardingOption('Un ami', 'A friend', Icons.person_outline_rounded),
  ];

  static const _levelOptions = [
    _OnboardingOption('Nul', 'None', Icons.sentiment_dissatisfied_outlined),
    _OnboardingOption('Débutant', 'Beginner', Icons.school_outlined),
    _OnboardingOption('Intermédiaire', 'Intermediate', Icons.trending_up),
    _OnboardingOption('Expert', 'Expert', Icons.emoji_events_outlined),
  ];

  static const _reasonOptions = [
    _OnboardingOption('Parler avec la famille', 'Talk with family', Icons.home_outlined),
    _OnboardingOption('Parler avec les amis', 'Talk with friends', Icons.groups_outlined),
    _OnboardingOption('Pour le fun', 'For fun', Icons.celebration_outlined),
    _OnboardingOption('Pour moi-même', 'For myself', Icons.favorite_border_rounded),
  ];

  static const _goalOptions = [
    _OnboardingOption('10 min/j', '10 min/day', Icons.timer_outlined),
    _OnboardingOption('15 min/j', '15 min/day', Icons.av_timer_rounded),
    _OnboardingOption('Skip', 'Skip', Icons.skip_next_rounded),
  ];

  int _step = 0;
  String? _source;
  String? _level;
  String? _reason;
  String? _goal;
  bool _notificationsEnabled = false;
  bool _isSaving = false;

  double get _progress => (_step + 1) / 6;

  bool get _canContinue {
    return switch (_step) {
      0 => _source != null,
      1 => _level != null,
      2 => _reason != null,
      3 => _goal != null,
      _ => true,
    };
  }

  void _next() {
    if (!_canContinue) return;
    if (_step == 5) {
      _finish();
      return;
    }

    setState(() => _step += 1);
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  Future<void> _finish() async {
    setState(() => _isSaving = true);
    await widget.onComplete(
      OnboardingProfile(
        source: _source ?? 'Non renseigné',
        level: _level ?? 'Non renseigné',
        reason: _reason ?? 'Non renseigné',
        goal: _goal ?? 'Skip',
        notificationsEnabled: _notificationsEnabled,
      ),
    );
  }

  Future<void> _setNotificationsEnabled(bool value) async {
    if (!value) {
      setState(() => _notificationsEnabled = false);
      return;
    }

    try {
      final granted =
          await _notificationChannel.invokeMethod<bool>('requestPermission') ??
              false;

      if (!mounted) return;
      setState(() => _notificationsEnabled = granted);

      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              RifinoText.tr(
                context,
                fr: 'Notifications non activées pour le moment.',
                en: 'Notifications are not enabled for now.',
              ),
            ),
          ),
        );
      }
    } on PlatformException {
      if (!mounted) return;
      setState(() => _notificationsEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            RifinoText.tr(
              context,
              fr: 'Impossible de demander la permission de notification.',
              en: 'Unable to request notification permission.',
            ),
          ),
        ),
      );
    } on MissingPluginException {
      if (!mounted) return;
      setState(() => _notificationsEnabled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = switch (_step) {
      0 => _ChoiceStep(
          title: RifinoText.tr(
            context,
            fr: 'Comment tu as entendu parler de Rifino ?',
            en: 'How did you hear about Rifino?',
          ),
          subtitle: RifinoText.tr(
            context,
            fr: 'Ça nous aide à savoir où la communauté nous trouve.',
            en: 'This helps us know where the community finds us.',
          ),
          options: _sourceOptions,
          selectedValue: _source,
          onSelected: (value) => setState(() => _source = value),
        ),
      1 => _ChoiceStep(
          title: RifinoText.tr(
            context,
            fr: 'Ton niveau en rifain ?',
            en: 'Your level in Rif?',
          ),
          subtitle: RifinoText.tr(
            context,
            fr: 'Choisis le niveau qui te ressemble maintenant.',
            en: 'Choose the level that fits you right now.',
          ),
          options: _levelOptions,
          selectedValue: _level,
          onSelected: (value) => setState(() => _level = value),
        ),
      2 => _ChoiceStep(
          title: RifinoText.tr(
            context,
            fr: 'Pourquoi tu utilises Rifino ?',
            en: 'Why do you use Rifino?',
          ),
          subtitle: RifinoText.tr(
            context,
            fr: 'On adaptera mieux les leçons et les rappels.',
            en: 'We will better adapt lessons and reminders.',
          ),
          options: _reasonOptions,
          selectedValue: _reason,
          onSelected: (value) => setState(() => _reason = value),
        ),
      3 => _ChoiceStep(
          title: RifinoText.tr(
            context,
            fr: 'Tu veux fixer un objectif ?',
            en: 'Do you want to set a goal?',
          ),
          subtitle: RifinoText.tr(
            context,
            fr: 'Un petit rythme régulier suffit pour progresser.',
            en: 'A small regular rhythm is enough to progress.',
          ),
          options: _goalOptions,
          selectedValue: _goal,
          onSelected: (value) => setState(() => _goal = value),
        ),
      4 => _NotificationStep(
          enabled: _notificationsEnabled,
          onChanged: _setNotificationsEnabled,
        ),
      _ => const _WelcomeStep(),
    };

    return Scaffold(
      backgroundColor: RifinoColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _step == 0 || _isSaving ? null : _back,
                    icon: const Icon(Icons.chevron_left_rounded, size: 30),
                  ),
                  const Expanded(
                    child: Center(child: RifinoLogo(width: 108, height: 50)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RifinoRadius.pill),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: RifinoColors.surfaceMuted,
                  color: RifinoColors.accentBlue,
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Padding(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
                  child: content,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: RifinoPrimaryButton(
                label: _step == 5
                    ? RifinoText.tr(context, fr: 'Entrer dans Rifino', en: 'Enter Rifino')
                    : RifinoText.tr(context, fr: 'Continuer', en: 'Continue'),
                icon: _step == 5 ? Icons.home_rounded : Icons.arrow_forward_rounded,
                isLoading: _isSaving,
                onPressed: _canContinue && !_isSaving ? _next : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final List<_OnboardingOption> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: RifinoSpacing.xs),
        Text(
          subtitle,
          style: const TextStyle(
            color: RifinoColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: RifinoSpacing.lg),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
            child: _OptionTile(
              option: option,
              selected: selectedValue == option.label,
              onTap: () => onSelected(option.label),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationStep extends StatelessWidget {
  const _NotificationStep({
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          RifinoText.tr(
            context,
            fr: 'Activer les notifications ?',
            en: 'Enable notifications?',
          ),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: RifinoSpacing.xs),
        Text(
          RifinoText.tr(
            context,
            fr: 'Rifino pourra te rappeler ton objectif et tes mots à réviser.',
            en: 'Rifino can remind you about your goal and words to review.',
          ),
          style: const TextStyle(
            color: RifinoColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: RifinoSpacing.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            color: RifinoColors.surface,
            borderRadius: BorderRadius.circular(RifinoRadius.lg),
            border: Border.all(
              color: enabled ? RifinoColors.accentBlue : RifinoColors.border,
              width: enabled ? 1.6 : 1,
            ),
          ),
          child: SwitchListTile.adaptive(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: RifinoColors.accentBlue,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RifinoSpacing.md,
              vertical: RifinoSpacing.sm,
            ),
            secondary: const CircleAvatar(
              backgroundColor: Color(0xFFEAF2FF),
              child: Icon(Icons.notifications_active_outlined, color: RifinoColors.accentBlue),
            ),
            title: Text(
              RifinoText.tr(
                context,
                fr: 'Me rappeler de pratiquer',
                en: 'Remind me to practice',
              ),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: Text(
              RifinoText.tr(
                context,
                fr: 'Tu peux changer ça plus tard.',
                en: 'You can change this later.',
              ),
              style: const TextStyle(color: RifinoColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: RifinoColors.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: RifinoColors.primary.withValues(alpha: 0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.white,
              size: 52,
            ),
          ),
          const SizedBox(height: RifinoSpacing.xl),
          Text(
            RifinoText.tr(context, fr: 'Azul, bienvenue !', en: 'Azul, welcome!'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: RifinoSpacing.sm),
          Text(
            RifinoText.tr(
              context,
              fr: 'Ton espace Rifino est prêt. On commence doucement, avec des mots utiles et un rythme simple.',
              en: 'Your Rifino space is ready. We start gently, with useful words and a simple rhythm.',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _OnboardingOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = RifinoLanguageScope.isEnglish(context)
        ? option.englishLabel
        : option.label;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RifinoRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(RifinoSpacing.md),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : RifinoColors.surface,
          borderRadius: BorderRadius.circular(RifinoRadius.lg),
          border: Border.all(
            color: selected ? RifinoColors.accentBlue : RifinoColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: selected ? RifinoColors.accentBlue : RifinoColors.surfaceMuted,
              child: Icon(
                option.icon,
                color: selected ? Colors.white : RifinoColors.primary,
              ),
            ),
            const SizedBox(width: RifinoSpacing.md),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: selected ? RifinoColors.accentBlue : RifinoColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingOption {
  const _OnboardingOption(this.label, this.englishLabel, this.icon);

  final String label;
  final String englishLabel;
  final IconData icon;
}
