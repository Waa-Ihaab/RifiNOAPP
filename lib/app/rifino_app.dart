import 'package:flutter/material.dart';
import 'package:rifino/app/app_shell.dart';
import 'package:rifino/core/services/onboarding_response_service.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/core/theme/rifino_theme.dart';
import 'package:rifino/features/onboarding/onboarding_screen.dart';
import 'package:rifino/shared/localization/rifino_language.dart';
import 'package:rifino/shared/widgets/rifino_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RifinoApp extends StatefulWidget {
  const RifinoApp({super.key});

  @override
  State<RifinoApp> createState() => _RifinoAppState();
}

class _RifinoAppState extends State<RifinoApp> {
  static const _onboardingDoneKey = 'rifino.onboarding.done';
  static const _languageKey = 'rifino.language.code';
  static const _onboardingResponseService = OnboardingResponseService();

  bool? _hasCompletedOnboarding;
  String _languageCode = 'fr';

  @override
  void initState() {
    super.initState();
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hasCompletedOnboarding = preferences.getBool(_onboardingDoneKey) ?? false;
      _languageCode = preferences.getString(_languageKey) ?? 'fr';
    });
  }

  Future<void> _setLanguage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, languageCode);
    if (!mounted) return;
    setState(() => _languageCode = languageCode);
  }

  Future<void> _completeOnboarding(OnboardingProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingDoneKey, true);
    await preferences.setString('rifino.onboarding.source', profile.source);
    await preferences.setString('rifino.onboarding.level', profile.level);
    await preferences.setString('rifino.onboarding.reason', profile.reason);
    await preferences.setString('rifino.onboarding.goal', profile.goal);
    await preferences.setBool(
      'rifino.onboarding.notifications',
      profile.notificationsEnabled,
    );

    try {
      await _onboardingResponseService.saveResponse(profile);
    } catch (error) {
      debugPrint('Unable to save onboarding response: $error');
      // The app can continue even if analytics storage is temporarily unavailable.
    }

    if (!mounted) return;
    setState(() => _hasCompletedOnboarding = true);
  }

  @override
  Widget build(BuildContext context) {
    return RifinoLanguageScope(
      languageCode: _languageCode,
      child: MaterialApp(
        title: 'Rifino',
        debugShowCheckedModeBanner: false,
        theme: RifinoTheme.light,
        home: _hasCompletedOnboarding == null
            ? const _StartupScreen()
            : _hasCompletedOnboarding!
                ? AppShell(
                    languageCode: _languageCode,
                    onLanguageChanged: _setLanguage,
                  )
                : OnboardingScreen(onComplete: _completeOnboarding),
      ),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: RifinoColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RifinoLogo(width: 156, height: 72),
            SizedBox(height: RifinoSpacing.lg),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: RifinoColors.accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
