class RifinoLesson {
  const RifinoLesson({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.vocabulary,
    required this.content,
    required this.examples,
    this.finished = false,
  });

  final String id;
  final String level;
  final String title;
  final String description;
  final List<RifinoVocabularyWord> vocabulary;
  final List<String> content;
  final List<String> examples;
  final bool finished;
}

class RifinoVocabularyWord {
  const RifinoVocabularyWord({
    required this.rif,
    required this.fr,
    required this.pronunciation,
  });

  final String rif;
  final String fr;
  final String pronunciation;

  String get label => '$rif - $fr';
}

const rifinoLessons = [
  RifinoLesson(
    id: 'lesson-1',
    level: 'Fondation',
    title: 'Pronoms personnels',
    description:
        'Apprends les mots essentiels pour parler de toi et des autres.',
    vocabulary: [
      RifinoVocabularyWord(rif: 'Nach', fr: 'Moi', pronunciation: 'nach'),
      RifinoVocabularyWord(rif: 'Chak', fr: 'Toi', pronunciation: 'chak'),
      RifinoVocabularyWord(rif: 'Netta', fr: 'Il', pronunciation: 'net-ta'),
      RifinoVocabularyWord(rif: 'Nettath', fr: 'Elle', pronunciation: 'net-tath'),
      RifinoVocabularyWord(rif: 'Nachin', fr: 'Nous', pronunciation: 'na-chin'),
    ],
    content: [
      'Les pronoms personnels servent à désigner une personne dans une phrase.',
      'En rifain, ils changent selon la personne: moi, toi, il, elle, nous, vous, eux.',
      'Commence par retenir les pronoms les plus utiles: nach, chak, netta et nettath.',
    ],
    examples: [
      'nach = moi',
      'chak = toi',
      'netta = il',
      'nettath = elle',
    ],
    finished: true,
  ),
  RifinoLesson(
    id: 'lesson-2',
    level: 'Fondation',
    title: 'Famille',
    description: 'Les mots utiles pour présenter ta famille.',
    vocabulary: [
      RifinoVocabularyWord(rif: 'Baba', fr: 'Père', pronunciation: 'ba-ba'),
      RifinoVocabularyWord(rif: 'Yemma', fr: 'Mère', pronunciation: 'yem-ma'),
      RifinoVocabularyWord(rif: 'Oma', fr: 'Frère', pronunciation: 'o-ma'),
      RifinoVocabularyWord(rif: 'Otchma', fr: 'Sœur', pronunciation: 'otch-ma'),
      RifinoVocabularyWord(rif: 'Jeddi', fr: 'Grand-père', pronunciation: 'jed-di'),
    ],
    content: [
      'Cette leçon regroupe les mots de base pour parler de ta famille.',
      "Apprends d'abord baba et yemma, puis ajoute les frères, sœurs et proches.",
      'Ces mots sont très utiles dans une présentation simple.',
    ],
    examples: [
      'baba = père',
      'yemma = mère',
      'oma = frère',
      'otchma = sœur',
    ],
  ),
  RifinoLesson(
    id: 'lesson-3',
    level: 'Maison',
    title: 'À la maison',
    description: 'Pièces, objets et expressions du quotidien.',
    vocabulary: [
      RifinoVocabularyWord(rif: 'Tadath', fr: 'Maison', pronunciation: 'ta-dath'),
      RifinoVocabularyWord(rif: 'Akaham', fr: 'Chambre', pronunciation: 'a-ka-ham'),
      RifinoVocabularyWord(rif: 'Tawath', fr: 'Porte', pronunciation: 'ta-wath'),
      RifinoVocabularyWord(rif: 'Tabra', fr: 'Table', pronunciation: 'ta-bra'),
    ],
    content: [
      'Cette leçon te donne le vocabulaire courant de la maison.',
      'Tu peux utiliser ces mots pour décrire ou demander où se trouve quelque chose.',
      'Retenir les objets du quotidien aide beaucoup pour parler naturellement.',
    ],
    examples: [
      'tadath = maison',
      'akaham = chambre',
      'tawath = porte',
      'tabra = table',
    ],
  ),
  RifinoLesson(
    id: 'lesson-4',
    level: 'Conversation',
    title: 'Expressions simples',
    description: 'Dire bonjour, remercier et répondre naturellement.',
    vocabulary: [
      RifinoVocabularyWord(rif: 'Azul', fr: 'Bonjour', pronunciation: 'a-zul'),
      RifinoVocabularyWord(rif: 'Hafek', fr: 'Merci', pronunciation: 'ha-fek'),
      RifinoVocabularyWord(rif: 'Wakha', fr: "D'accord", pronunciation: 'wa-kha'),
      RifinoVocabularyWord(rif: 'Waha', fr: 'Oui', pronunciation: 'wa-ha'),
      RifinoVocabularyWord(rif: 'La', fr: 'Non', pronunciation: 'la'),
    ],
    content: [
      'Les expressions simples permettent de commencer une conversation.',
      'Elles sont courtes, faciles à retenir et très fréquentes.',
      'Travaille la prononciation en les répétant plusieurs fois.',
    ],
    examples: [
      'azul = bonjour',
      'hafek = merci',
      'waha = oui',
      'la = non',
    ],
  ),
  RifinoLesson(
    id: 'lesson-5',
    level: 'Débutant',
    title: 'Compter de 1 à 5',
    description: 'Maîtrise les nombres de base pour compter au quotidien.',
    vocabulary: [
      RifinoVocabularyWord(rif: 'Wahid', fr: 'Un', pronunciation: 'wa-hid'),
      RifinoVocabularyWord(rif: 'Tnayen', fr: 'Deux', pronunciation: 't-na-yen'),
      RifinoVocabularyWord(rif: 'Tratha', fr: 'Trois', pronunciation: 'tra-tha'),
      RifinoVocabularyWord(rif: 'Arabaa', fr: 'Quatre', pronunciation: 'a-ra-baa'),
      RifinoVocabularyWord(rif: 'Khamssa', fr: 'Cinq', pronunciation: 'kham-ssa'),
    ],
    content: [
      'Les nombres de un à cinq servent dans beaucoup de phrases simples.',
      'Répète chaque mot lentement, puis enchaîne la série complète.',
    ],
    examples: [
      'wahid = un',
      'tnayen = deux',
      'tratha = trois',
      'arabaa = quatre',
      'khamssa = cinq',
    ],
  ),
];
