import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';

class DictionaryEntry {
  const DictionaryEntry({
    required this.fr,
    required this.rif,
  });

  final String fr;
  final String rif;
}

class DictionaryCategory {
  const DictionaryCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.entries,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<DictionaryEntry> entries;
}

const dictionaryCategories = [
  DictionaryCategory(
    title: 'Pronoms et informations personnelles',
    icon: Icons.person_outline,
    color: RifinoColors.accentBlue,
    entries: [
      DictionaryEntry(fr: 'moi', rif: 'nach'),
      DictionaryEntry(fr: 'toi', rif: 'chak'),
      DictionaryEntry(fr: 'il', rif: 'netta'),
      DictionaryEntry(fr: 'elle', rif: 'nettath'),
      DictionaryEntry(fr: 'nous', rif: 'nachin'),
      DictionaryEntry(fr: 'vous', rif: 'kaniw'),
      DictionaryEntry(fr: 'eux', rif: 'nithni'),
      DictionaryEntry(fr: 'nom', rif: 'takniya'),
      DictionaryEntry(fr: 'prénom', rif: 'issam'),
      DictionaryEntry(fr: 'âge', rif: 'r3omwa'),
      DictionaryEntry(fr: 'pays', rif: 'doula'),
      DictionaryEntry(fr: 'ville', rif: 'abilaj'),
    ],
  ),
  DictionaryCategory(
    title: 'Famille',
    icon: Icons.groups_outlined,
    color: RifinoColors.success,
    entries: [
      DictionaryEntry(fr: 'père', rif: 'baba'),
      DictionaryEntry(fr: 'mère', rif: 'yemma'),
      DictionaryEntry(fr: 'frère', rif: 'oma'),
      DictionaryEntry(fr: 'sœur', rif: 'otchma'),
      DictionaryEntry(fr: 'enfant', rif: 'ahanja'),
      DictionaryEntry(fr: 'grand-père', rif: 'jeddi'),
      DictionaryEntry(fr: 'grand-mère', rif: 'henna'),
      DictionaryEntry(fr: 'ami', rif: 'amadokar'),
    ],
  ),
  DictionaryCategory(
    title: 'Nombres',
    icon: Icons.pin_rounded,
    color: RifinoColors.accentBlue,
    entries: [
      DictionaryEntry(fr: 'un', rif: 'wahid'),
      DictionaryEntry(fr: 'deux', rif: 'tnayen'),
      DictionaryEntry(fr: 'trois', rif: 'tratha'),
      DictionaryEntry(fr: 'quatre', rif: 'arabaa'),
      DictionaryEntry(fr: 'cinq', rif: 'khamssa'),
    ],
  ),
  DictionaryCategory(
    title: 'Maison',
    icon: Icons.home_outlined,
    color: RifinoColors.danger,
    entries: [
      DictionaryEntry(fr: 'maison', rif: 'tadath'),
      DictionaryEntry(fr: 'chambre', rif: 'akaham'),
      DictionaryEntry(fr: 'salon', rif: 'sala'),
      DictionaryEntry(fr: 'cuisine', rif: 'kuzina'),
      DictionaryEntry(fr: 'lit', rif: '9ama'),
      DictionaryEntry(fr: 'table', rif: 'tabra'),
      DictionaryEntry(fr: 'porte', rif: 'tawath'),
      DictionaryEntry(fr: 'clé', rif: 'raftah'),
    ],
  ),
  DictionaryCategory(
    title: 'Nature',
    icon: Icons.eco_outlined,
    color: Color(0xFF2F8A3E),
    entries: [
      DictionaryEntry(fr: 'eau', rif: 'aman'),
      DictionaryEntry(fr: 'soleil', rif: 'tfocht'),
      DictionaryEntry(fr: 'lune', rif: 'taziri'),
      DictionaryEntry(fr: 'pluie', rif: 'anza'),
      DictionaryEntry(fr: 'mer', rif: 'rabha'),
      DictionaryEntry(fr: 'montagne', rif: 'adhra'),
      DictionaryEntry(fr: 'arbre', rif: 'ssja'),
    ],
  ),
  DictionaryCategory(
    title: 'Nourriture',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFD14A2F),
    entries: [
      DictionaryEntry(fr: 'pain', rif: 'aghrom'),
      DictionaryEntry(fr: 'lait', rif: 'aghi'),
      DictionaryEntry(fr: 'fromage', rif: 'fomaj'),
      DictionaryEntry(fr: 'viande', rif: 'ayssom'),
      DictionaryEntry(fr: 'poulet', rif: 'yazidh'),
      DictionaryEntry(fr: 'thé', rif: 'atay'),
      DictionaryEntry(fr: 'café', rif: '9ahwa'),
    ],
  ),
  DictionaryCategory(
    title: 'Expressions',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFF9A4D9E),
    entries: [
      DictionaryEntry(fr: 'bonjour', rif: 'azul'),
      DictionaryEntry(fr: 'merci', rif: 'hafek'),
      DictionaryEntry(fr: 'oui', rif: 'waha'),
      DictionaryEntry(fr: 'non', rif: 'lah'),
      DictionaryEntry(fr: "d'accord", rif: 'wakha'),
    ],
  ),
  DictionaryCategory(
    title: 'Transport',
    icon: Icons.directions_car_outlined,
    color: Color(0xFF455A64),
    entries: [
      DictionaryEntry(fr: 'voiture', rif: 'tonobin'),
      DictionaryEntry(fr: 'bus', rif: 'lbuss'),
      DictionaryEntry(fr: 'train', rif: 'machina'),
      DictionaryEntry(fr: 'avion', rif: 'tiyara'),
      DictionaryEntry(fr: 'route', rif: 'abrid'),
    ],
  ),
  DictionaryCategory(
    title: 'Adjectifs',
    icon: Icons.color_lens_outlined,
    color: Color(0xFF3F51B5),
    entries: [
      DictionaryEntry(fr: 'grand', rif: 'dazira'),
      DictionaryEntry(fr: 'petit', rif: 'da9odadh'),
      DictionaryEntry(fr: 'facile', rif: 'yahwan'),
      DictionaryEntry(fr: 'difficile', rif: 'i9ssah'),
      DictionaryEntry(fr: 'rapide', rif: 'daghya'),
      DictionaryEntry(fr: 'bon', rif: 'ichna'),
    ],
  ),
];

int get dictionaryWordCount {
  return dictionaryCategories.fold(0, (total, item) => total + item.entries.length);
}
