import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
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
    _OnboardingOption('Facebook', Icons.facebook),
    _OnboardingOption('TikTok', Icons.music_note_rounded),
    _OnboardingOption('Instagram', Icons.camera_alt_outlined),
    _OnboardingOption('Google', Icons.search_rounded),
    _OnboardingOption('App Store', Icons.apps_rounded),
    _OnboardingOption('Un ami', Icons.person_outline_rounded),
  ];

  static const _levelOptions = [
    _OnboardingOption('Nul', Icons.sentiment_dissatisfied_outlined),
    _OnboardingOption('Débutant', Icons.school_outlined),
    _OnboardingOption('Intermédiaire', Icons.trending_up),
    _OnboardingOption('Expert', Icons.emoji_events_outlined),
  ];

  static const _reasonOptions = [
    _OnboardingOption('Parler avec la famille', Icons.home_outlined),
    _OnboardingOption('Parler avec les amis', Icons.groups_outlined),
    _OnboardingOption('Pour le fun', Icons.celebration_outlined),
    _OnboardingOption('Pour moi-même', Icons.favorite_border_rounded),
  ];

  static const _goalOptions = [
    _OnboardingOption('10 min/j', Icons.timer_outlined),
    _OnboardingOption('15 min/j', Icons.av_timer_rounded),
    _OnboardingOption('Skip', Icons.skip_next_rounded),
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
          const SnackBar(
            content: Text('Notifications non activées pour le moment.'),
          ),
        );
      }
    } on PlatformException {
      if (!mounted) return;
      setState(() => _notificationsEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de demander la permission de notification.'),
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
          title: 'Comment tu as entendu parler de Rifino ?',
          subtitle: 'Ça nous aide à savoir où la communauté nous trouve.',
          options: _sourceOptions,
          selectedValue: _source,
          onSelected: (value) => setState(() => _source = value),
        ),
      1 => _ChoiceStep(
          title: 'Ton niveau en rifain ?',
          subtitle: 'Choisis le niveau qui te ressemble maintenant.',
          options: _levelOptions,
          selectedValue: _level,
          onSelected: (value) => setState(() => _level = value),
        ),
      2 => _ChoiceStep(
          title: 'Pourquoi tu utilises Rifino ?',
          subtitle: 'On adaptera mieux les leçons et les rappels.',
          options: _reasonOptions,
          selectedValue: _reason,
          onSelected: (value) => setState(() => _reason = value),
        ),
      3 => _ChoiceStep(
          title: 'Tu veux fixer un objectif ?',
          subtitle: 'Un petit rythme régulier suffit pour progresser.',
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
                label: _step == 5 ? 'Entrer dans Rifino' : 'Continuer',
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
        Text('Activer les notifications ?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: RifinoSpacing.xs),
        const Text(
          'Rifino pourra te rappeler ton objectif et tes mots à réviser.',
          style: TextStyle(
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
            title: const Text(
              'Me rappeler de pratiquer',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: const Text(
              'Tu peux changer ça plus tard.',
              style: TextStyle(color: RifinoColors.textSecondary),
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
            'Azul, bienvenue !',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: RifinoSpacing.sm),
          const Text(
            'Ton espace Rifino est prêt. On commence doucement, avec des mots utiles et un rythme simple.',
            textAlign: TextAlign.center,
            style: TextStyle(
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
                option.label,
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
  const _OnboardingOption(this.label, this.icon);

  final String label;
  final IconData icon;
}
