import 'package:flutter/widgets.dart';

class RifinoLanguageScope extends InheritedWidget {
  const RifinoLanguageScope({
    required this.languageCode,
    required super.child,
    super.key,
  });

  final String languageCode;

  static String codeOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<RifinoLanguageScope>()
            ?.languageCode ??
        'fr';
  }

  static bool isEnglish(BuildContext context) => codeOf(context) == 'en';

  @override
  bool updateShouldNotify(RifinoLanguageScope oldWidget) {
    return languageCode != oldWidget.languageCode;
  }
}

class RifinoText {
  const RifinoText._();

  static String tr(
    BuildContext context, {
    required String fr,
    required String en,
  }) {
    return _pick(context, fr: fr, en: en);
  }

  static String settingsTitle(BuildContext context) =>
      _pick(context, fr: 'Réglages', en: 'Settings');

  static String settingsSubtitle(BuildContext context) => _pick(
        context,
        fr: 'Personnalise ton expérience Rifino.',
        en: 'Customize your Rifino experience.',
      );

  static String language(BuildContext context) =>
      _pick(context, fr: 'Langue', en: 'Language');

  static String appLanguage(BuildContext context) => _pick(
        context,
        fr: "Langue de l'application",
        en: 'App language',
      );

  static String about(BuildContext context) =>
      _pick(context, fr: 'À propos', en: 'About');

  static String madeForRif(BuildContext context) =>
      _pick(context, fr: 'Fait pour le Rif', en: 'Made for the Rif');

  static String footer(BuildContext context) =>
      _pick(context, fr: 'Rifino - Apprenons le Rif', en: 'Rifino - Learn Rif');

  static String home(BuildContext context) =>
      _pick(context, fr: 'Accueil', en: 'Home');

  static String learning(BuildContext context) =>
      _pick(context, fr: 'Apprendre', en: 'Learn');

  static String saved(BuildContext context) =>
      _pick(context, fr: 'Enregistrés', en: 'Saved');

  static String settings(BuildContext context) =>
      _pick(context, fr: 'Réglages', en: 'Settings');

  static String dailyPracticeTitle(BuildContext context) =>
      _pick(context, fr: 'Pratique du jour', en: 'Daily practice');

  static String dailyPracticeBody(BuildContext context) => _pick(
        context,
        fr: 'Reprends 5 minutes de rifain pour garder ton rythme.',
        en: 'Review 5 minutes of Rif to keep your rhythm.',
      );

  static String dictionaryCategory(BuildContext context, String title) {
    if (!RifinoLanguageScope.isEnglish(context)) return title;

    return switch (title) {
      'Pronoms et informations personnelles' => 'Pronouns and personal info',
      'Pronoms personnels' => 'Personal pronouns',
      'Famille' => 'Family',
      'Nombres' => 'Numbers',
      'Maison' => 'Home',
      'Nature' => 'Nature',
      'Nourriture' => 'Food',
      'Expressions' => 'Expressions',
      'Transport' => 'Transport',
      'Adjectifs' => 'Adjectives',
      _ => title,
    };
  }

  static String word(BuildContext context, String fr) {
    if (!RifinoLanguageScope.isEnglish(context)) return fr;

    return switch (fr.toLowerCase()) {
      'moi' => 'me',
      'toi' => 'you',
      'il' => 'he',
      'elle' => 'she',
      'nous' => 'we',
      'vous' => 'you',
      'eux' => 'them',
      'nom' => 'last name',
      'prénom' => 'first name',
      'âge' => 'age',
      'pays' => 'country',
      'ville' => 'city',
      'père' => 'father',
      'mère' => 'mother',
      'frère' => 'brother',
      'sœur' => 'sister',
      'enfant' => 'child',
      'grand-père' => 'grandfather',
      'grand-mère' => 'grandmother',
      'ami' => 'friend',
      'un' => 'one',
      'deux' => 'two',
      'trois' => 'three',
      'quatre' => 'four',
      'cinq' => 'five',
      'maison' => 'house',
      'chambre' => 'bedroom',
      'salon' => 'living room',
      'cuisine' => 'kitchen',
      'lit' => 'bed',
      'table' => 'table',
      'porte' => 'door',
      'clé' => 'key',
      'eau' => 'water',
      'soleil' => 'sun',
      'lune' => 'moon',
      'pluie' => 'rain',
      'mer' => 'sea',
      'montagne' => 'mountain',
      'arbre' => 'tree',
      'pain' => 'bread',
      'lait' => 'milk',
      'fromage' => 'cheese',
      'viande' => 'meat',
      'poulet' => 'chicken',
      'thé' => 'tea',
      'café' => 'coffee',
      'bonjour' => 'hello',
      'merci' => 'thank you',
      'oui' => 'yes',
      'non' => 'no',
      "d'accord" => 'okay',
      'voiture' => 'car',
      'bus' => 'bus',
      'train' => 'train',
      'avion' => 'plane',
      'route' => 'road',
      'grand' => 'big',
      'petit' => 'small',
      'facile' => 'easy',
      'difficile' => 'difficult',
      'rapide' => 'fast',
      'bon' => 'good',
      _ => fr,
    };
  }

  static String lessonLevel(BuildContext context, String level) {
    if (!RifinoLanguageScope.isEnglish(context)) return level;

    return switch (level) {
      'Fondation' => 'Foundation',
      'Maison' => 'Home',
      'Conversation' => 'Conversation',
      'Débutant' => 'Beginner',
      _ => level,
    };
  }

  static String lessonTitle(BuildContext context, String id, String fallback) {
    if (!RifinoLanguageScope.isEnglish(context)) return fallback;

    return switch (id) {
      'lesson-1' => 'Personal pronouns',
      'lesson-2' => 'Family',
      'lesson-3' => 'At home',
      'lesson-4' => 'Simple expressions',
      'lesson-5' => 'Count from 1 to 5',
      _ => fallback,
    };
  }

  static String lessonDescription(
    BuildContext context,
    String id,
    String fallback,
  ) {
    if (!RifinoLanguageScope.isEnglish(context)) return fallback;

    return switch (id) {
      'lesson-1' => 'Learn essential words to talk about yourself and others.',
      'lesson-2' => 'Useful words to introduce your family.',
      'lesson-3' => 'Rooms, objects and everyday expressions.',
      'lesson-4' => 'Say hello, thank people and answer naturally.',
      'lesson-5' => 'Master basic numbers for everyday counting.',
      _ => fallback,
    };
  }

  static List<String> lessonContent(
    BuildContext context,
    String id,
    List<String> fallback,
  ) {
    if (!RifinoLanguageScope.isEnglish(context)) return fallback;

    return switch (id) {
      'lesson-1' => const [
          'Personal pronouns are used to refer to a person in a sentence.',
          'In Rif, they change depending on the person: me, you, he, she, we, you, them.',
          'Start by memorizing the most useful pronouns: nach, chak, netta and nettath.',
        ],
      'lesson-2' => const [
          'This lesson gathers basic words to talk about your family.',
          'First learn baba and yemma, then add brothers, sisters and close relatives.',
          'These words are very useful in a simple introduction.',
        ],
      'lesson-3' => const [
          'This lesson gives you common vocabulary for the home.',
          'You can use these words to describe or ask where something is.',
          'Remembering everyday objects helps a lot when speaking naturally.',
        ],
      'lesson-4' => const [
          'Simple expressions help you start a conversation.',
          'They are short, easy to remember and very common.',
          'Work on pronunciation by repeating them several times.',
        ],
      'lesson-5' => const [
          'Numbers from one to five are used in many simple sentences.',
          'Repeat each word slowly, then say the full sequence.',
        ],
      _ => fallback,
    };
  }

  static List<String> lessonExamples(
    BuildContext context,
    String id,
    List<String> fallback,
  ) {
    if (!RifinoLanguageScope.isEnglish(context)) return fallback;

    return switch (id) {
      'lesson-1' => const ['nach = me', 'chak = you', 'netta = he', 'nettath = she'],
      'lesson-2' => const ['baba = father', 'yemma = mother', 'oma = brother', 'otchma = sister'],
      'lesson-3' => const ['tadath = house', 'akaham = bedroom', 'tawath = door', 'tabra = table'],
      'lesson-4' => const ['azul = hello', 'hafek = thank you', 'waha = yes', 'la = no'],
      'lesson-5' => const ['wahid = one', 'tnayen = two', 'tratha = three', 'arabaa = four', 'khamssa = five'],
      _ => fallback,
    };
  }

  static String _pick(
    BuildContext context, {
    required String fr,
    required String en,
  }) {
    return RifinoLanguageScope.isEnglish(context) ? en : fr;
  }
}
