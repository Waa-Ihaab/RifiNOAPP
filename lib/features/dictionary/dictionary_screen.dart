import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/data/dictionary_data.dart';
import 'package:rifino/shared/models/saved_entry.dart';
import 'package:rifino/shared/widgets/rifino_top_bar.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({
    required this.savedIds,
    required this.onToggleSaved,
    this.initialCategory,
    this.initialQuery,
    this.onBack,
    super.key,
  });

  final Set<String> savedIds;
  final ValueChanged<SavedEntry> onToggleSaved;
  final String? initialCategory;
  final String? initialQuery;
  final VoidCallback? onBack;

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  static const _all = 'Tous';

  late final TextEditingController _searchController;
  late String _query;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _selectedCategory = widget.initialCategory ?? _all;
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = dictionaryCategories.expand((category) {
      final categoryMatches = _selectedCategory == _all || category.title == _selectedCategory;
      if (!categoryMatches) return <DictionaryCategory>[];

      final query = _query.trim().toLowerCase();
      final entries = query.isEmpty
          ? category.entries
          : category.entries.where((entry) {
              return '${entry.fr} ${entry.rif}'.toLowerCase().contains(query);
            }).toList();

      if (entries.isEmpty) return <DictionaryCategory>[];
      return [
        DictionaryCategory(
          title: category.title,
          icon: category.icon,
          color: category.color,
          entries: entries,
        ),
      ];
    }).toList();
    final visibleCount = filtered.fold(0, (sum, item) => sum + item.entries.length);

    return Scaffold(
      appBar: RifinoTopBar(title: 'Dictionnaire', onBack: widget.onBack),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 86),
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 104),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [RifinoColors.primary, Color(0xFF0A4B94)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: RifinoColors.primary.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Français - Rifain\n${dictionaryCategories.length} catégories - $dictionaryWordCount mots',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  child: const Icon(Icons.menu_book_outlined, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: RifinoSpacing.md),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Rechercher un mot',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: RifinoSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: _all,
                  active: _selectedCategory == _all,
                  onTap: () => setState(() {
                    _selectedCategory = _all;
                    _query = '';
                    _searchController.clear();
                  }),
                ),
                for (final category in dictionaryCategories)
                  _FilterChip(
                    label: category.title,
                    active: _selectedCategory == category.title,
                    onTap: () => setState(() {
                      _selectedCategory = category.title;
                      _query = '';
                      _searchController.clear();
                    }),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: RifinoSpacing.md),
            child: Text(
              '$visibleCount résultat${visibleCount > 1 ? 's' : ''}',
              style: const TextStyle(color: RifinoColors.purple, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
          for (final category in filtered)
            _CategoryBlock(
              category: category,
              savedIds: widget.savedIds,
              onToggleSaved: widget.onToggleSaved,
            ),
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: RifinoColors.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: RifinoColors.border),
              ),
              child: const Column(
                children: [
                  Icon(Icons.search, color: RifinoColors.textSecondary),
                  SizedBox(height: 8),
                  Text('Aucun mot trouvé', style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('Essaie un autre mot en français ou en rifain.'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: onTap,
        label: Text(label),
        backgroundColor: active ? RifinoColors.accentBlue : Colors.white,
        labelStyle: TextStyle(
          color: active ? Colors.white : RifinoColors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
        side: BorderSide(color: active ? RifinoColors.accentBlue : RifinoColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.savedIds,
    required this.onToggleSaved,
  });

  final DictionaryCategory category;
  final Set<String> savedIds;
  final ValueChanged<SavedEntry> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: category.color,
                child: Icon(category.icon, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('${category.entries.length} mots', style: const TextStyle(color: RifinoColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: RifinoColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (final entry in category.entries) _DictionaryRow(
                  category: category,
                  entry: entry,
                  saved: savedIds.contains(_wordSavedId(category.title, entry)),
                  onToggleSaved: onToggleSaved,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DictionaryRow extends StatelessWidget {
  const _DictionaryRow({
    required this.category,
    required this.entry,
    required this.saved,
    required this.onToggleSaved,
  });

  final DictionaryCategory category;
  final DictionaryEntry entry;
  final bool saved;
  final ValueChanged<SavedEntry> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final savedId = _wordSavedId(category.title, entry);

    return ListTile(
      dense: true,
      title: Text(entry.fr, style: const TextStyle(fontWeight: FontWeight.w900)),
      trailing: SizedBox(
        width: 164,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.arrow_forward, size: 15, color: RifinoColors.purple),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                entry.rif,
                textAlign: TextAlign.right,
                style: const TextStyle(color: RifinoColors.primary, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: saved ? 'Retirer' : 'Enregistrer',
              onPressed: () {
                onToggleSaved(
                  SavedEntry(
                    id: savedId,
                    kind: SavedEntryKind.word,
                    title: entry.rif,
                    subtitle: '${entry.fr} - ${category.title}',
                  ),
                );
              },
              icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
              color: saved ? RifinoColors.accentBlue : RifinoColors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

String _wordSavedId(String category, DictionaryEntry entry) {
  return 'word:$category:${entry.fr}:${entry.rif}';
}
