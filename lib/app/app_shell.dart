import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rifino/app/app_route.dart';
import 'package:rifino/features/audio/audio_screen.dart';
import 'package:rifino/features/dictionary/dictionary_screen.dart';
import 'package:rifino/features/home/home_screen.dart';
import 'package:rifino/features/learning/learning_screen.dart';
import 'package:rifino/features/lessons/lessons_screen.dart';
import 'package:rifino/features/quiz/quiz_screen.dart';
import 'package:rifino/features/saved/saved_screen.dart';
import 'package:rifino/features/settings/settings_screen.dart';
import 'package:rifino/shared/data/dictionary_data.dart';
import 'package:rifino/shared/models/saved_entry.dart';
import 'package:rifino/shared/widgets/rifino_bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _savedEntriesKey = 'rifino.saved.entries';
  static const _notificationReadIdsKey = 'rifino.notifications.read.ids';
  static const _onboardingNotificationsKey = 'rifino.onboarding.notifications';
  static const _activityDatesKey = 'rifino.activity.dates';

  AppRoute _route = AppRoute.home;
  AppRoute _previousRoute = AppRoute.home;
  String? _dictionaryInitialCategory;
  String? _dictionaryInitialQuery;
  String? _initialLessonId;
  bool _openInitialLesson = false;
  bool _notifications = false;
  final Map<String, SavedEntry> _savedEntries = {};
  final Set<String> _readNotificationIds = {};
  final Set<String> _activityDates = {};
  late final RifinoDailyWord _launchWord = _pickLaunchWord();

  @override
  void initState() {
    super.initState();
    _loadSavedEntries();
    _loadNotificationState();
    _loadActivityDates();
  }

  void _goTo(AppRoute route) {
    setState(() {
      if (route != _route) _previousRoute = _route;
      if (route != AppRoute.dictionary) {
        _dictionaryInitialCategory = null;
        _dictionaryInitialQuery = null;
      }
      if (route != AppRoute.lessons) {
        _initialLessonId = null;
        _openInitialLesson = false;
      }
      _route = route;
    });
  }

  void _openLesson(String lessonId) {
    setState(() {
      if (_route != AppRoute.lessons) _previousRoute = _route;
      _dictionaryInitialCategory = null;
      _dictionaryInitialQuery = null;
      _initialLessonId = lessonId;
      _openInitialLesson = true;
      _route = AppRoute.lessons;
    });
  }

  void _openDictionary({String? category, String? query}) {
    setState(() {
      if (_route != AppRoute.dictionary) _previousRoute = _route;
      _dictionaryInitialCategory = category;
      _dictionaryInitialQuery = query;
      _route = AppRoute.dictionary;
    });
  }

  void _openWordOfDay() {
    _openDictionary(
      category: _launchWord.category.title,
      query: _launchWord.entry.rif,
    );
  }

  RifinoDailyWord _pickLaunchWord() {
    final entries = [
      for (final category in dictionaryCategories)
        for (final entry in category.entries) RifinoDailyWord(category: category, entry: entry),
    ];
    final index = DateTime.now().microsecondsSinceEpoch % entries.length;
    return entries[index];
  }

  void _goBackFromDictionary() {
    final backRoute = switch (_previousRoute) {
      AppRoute.audio || AppRoute.quiz => AppRoute.learning,
      AppRoute.dictionary => AppRoute.home,
      _ => _previousRoute,
    };
    _goTo(backRoute);
  }

  Future<void> _loadSavedEntries() async {
    final preferences = await SharedPreferences.getInstance();
    final rawEntries = preferences.getStringList(_savedEntriesKey) ?? [];
    final entries = <String, SavedEntry>{};

    for (final rawEntry in rawEntries) {
      try {
        final decoded = jsonDecode(rawEntry);
        if (decoded is Map<String, Object?>) {
          final entry = SavedEntry.fromJson(decoded);
          if (entry != null) entries[entry.id] = entry;
        }
      } catch (_) {
        // Ignore malformed local data and keep the app usable.
      }
    }

    if (!mounted) return;
    setState(() {
      _savedEntries
        ..clear()
        ..addAll(entries);
    });
  }

  Future<void> _persistSavedEntries() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedEntries = _savedEntries.values
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();

    await preferences.setStringList(_savedEntriesKey, encodedEntries);
  }

  void _toggleSavedEntry(SavedEntry entry) {
    setState(() {
      if (_savedEntries.containsKey(entry.id)) {
        _savedEntries.remove(entry.id);
      } else {
        _savedEntries[entry.id] = entry;
      }
    });
    _persistSavedEntries();
  }

  void _removeSavedEntry(String id) {
    setState(() => _savedEntries.remove(id));
    _persistSavedEntries();
  }

  List<RifinoHomeNotification> get _homeNotifications {
    if (!_notifications) return const [];

    return const [
      RifinoHomeNotification(
        id: 'daily-practice',
        title: 'Pratique du jour',
        body: 'Reprends 5 minutes de rifain pour garder ton rythme.',
        icon: Icons.local_fire_department_rounded,
      ),
    ];
  }

  int get _unreadNotificationCount {
    return _homeNotifications
        .where((notification) => !_readNotificationIds.contains(notification.id))
        .length;
  }

  Future<void> _loadNotificationState() async {
    final preferences = await SharedPreferences.getInstance();
    final readIds = preferences.getStringList(_notificationReadIdsKey) ?? [];

    if (!mounted) return;
    setState(() {
      _notifications = preferences.getBool(_onboardingNotificationsKey) ?? false;
      _readNotificationIds
        ..clear()
        ..addAll(readIds);
    });
  }

  Future<void> _loadActivityDates() async {
    final preferences = await SharedPreferences.getInstance();
    final dates = preferences.getStringList(_activityDatesKey) ?? [];

    if (!mounted) return;
    setState(() {
      _activityDates
        ..clear()
        ..addAll(dates);
    });
  }

  Future<void> _markPracticeToday() async {
    final todayKey = _dateKey(DateTime.now());
    if (_activityDates.contains(todayKey)) return;

    setState(() => _activityDates.add(todayKey));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _activityDatesKey,
      _activityDates.toList()..sort(),
    );
  }

  Future<void> _persistNotificationState() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingNotificationsKey, _notifications);
    await preferences.setStringList(
      _notificationReadIdsKey,
      _readNotificationIds.toList()..sort(),
    );
  }

  void _markNotificationsOpened() {
    final ids = _homeNotifications.map((notification) => notification.id);
    setState(() => _readNotificationIds.addAll(ids));
    _persistNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    final showBottomNav = switch (_route) {
      AppRoute.home ||
      AppRoute.learning ||
      AppRoute.dictionary ||
      AppRoute.saved ||
      AppRoute.settings ||
      AppRoute.lessons =>
        true,
      AppRoute.audio || AppRoute.quiz => false,
    };

    final screen = switch (_route) {
      AppRoute.home => HomeScreen(
          onOpenLearning: () => _goTo(AppRoute.learning),
          onOpenDictionary: () => _openDictionary(),
          onOpenWordOfDay: _openWordOfDay,
          onOpenNumbers: () => _openDictionary(category: 'Nombres'),
          onOpenLessons: () => _goTo(AppRoute.lessons),
          onOpenLesson: _openLesson,
          wordOfDay: _launchWord,
          notifications: _homeNotifications,
          unreadNotificationCount: _unreadNotificationCount,
          onNotificationsOpened: _markNotificationsOpened,
          currentStreakDays: _currentStreakDays,
          activeWeekDays: _activeWeekDays,
        ),
      AppRoute.learning => LearningScreen(
          onOpenAudio: () => _goTo(AppRoute.audio),
          onOpenDictionary: () => _openDictionary(),
          onOpenQuiz: () => _goTo(AppRoute.quiz),
          onOpenLessons: () => _goTo(AppRoute.lessons),
        ),
      AppRoute.dictionary => DictionaryScreen(
          key: ValueKey('${_dictionaryInitialCategory ?? ''}:${_dictionaryInitialQuery ?? ''}'),
          savedIds: _savedEntries.keys.toSet(),
          onToggleSaved: _toggleSavedEntry,
          initialCategory: _dictionaryInitialCategory,
          initialQuery: _dictionaryInitialQuery,
          onBack: _goBackFromDictionary,
        ),
      AppRoute.saved => SavedScreen(
          entries: _savedEntries.values.toList(),
          onRemove: _removeSavedEntry,
        ),
      AppRoute.settings => const SettingsScreen(),
      AppRoute.audio => AudioScreen(
          onBack: () => _goTo(AppRoute.learning),
          savedIds: _savedEntries.keys.toSet(),
          onToggleSaved: _toggleSavedEntry,
          onPractice: _markPracticeToday,
        ),
      AppRoute.quiz => QuizScreen(
          onBack: () => _goTo(AppRoute.learning),
          onCompleted: _markPracticeToday,
        ),
      AppRoute.lessons => LessonsScreen(
          key: ValueKey('${_initialLessonId ?? ''}:$_openInitialLesson'),
          onBack: () => _goTo(AppRoute.learning),
          savedIds: _savedEntries.keys.toSet(),
          onToggleSaved: _toggleSavedEntry,
          initialLessonId: _initialLessonId,
          openInitialLesson: _openInitialLesson,
          onLessonCompleted: _markPracticeToday,
        ),
    };

    return Scaffold(
      body: screen,
      bottomNavigationBar: showBottomNav
          ? RifinoBottomNav(
              currentRoute: _route,
              onSelected: _goTo,
            )
          : null,
    );
  }

  List<bool> get _activeWeekDays {
    final today = DateTime.now();
    final startOfWeek = _dateOnly(today).subtract(
      Duration(days: today.weekday % DateTime.daysPerWeek),
    );

    return List.generate(DateTime.daysPerWeek, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return _activityDates.contains(_dateKey(date));
    });
  }

  int get _currentStreakDays {
    final today = _dateOnly(DateTime.now());
    final todayKey = _dateKey(today);
    final yesterday = today.subtract(const Duration(days: 1));
    var cursor = _activityDates.contains(todayKey) ? today : yesterday;

    if (!_activityDates.contains(_dateKey(cursor))) return 0;

    var count = 0;
    while (_activityDates.contains(_dateKey(cursor))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String _dateKey(DateTime date) {
  final normalized = _dateOnly(date);
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}
