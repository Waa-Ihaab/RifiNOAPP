import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/models/saved_entry.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:rifino/shared/widgets/rifino_top_bar.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    required this.entries,
    required this.onRemove,
    super.key,
  });

  final List<SavedEntry> entries;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final audios = entries.where((entry) => entry.kind == SavedEntryKind.audio).toList();
    final words = entries.where((entry) => entry.kind == SavedEntryKind.word).toList();
    final lessons = entries.where((entry) => entry.kind == SavedEntryKind.lesson).toList();

    return Scaffold(
      appBar: const RifinoTopBar(title: 'Enregistrés'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 104),
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 136),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: RifinoColors.primaryDark,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: RifinoColors.primaryDark.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Mes favoris\n${entries.length} élément${entries.length > 1 ? 's' : ''} gardé${entries.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.35,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.bookmark_rounded, color: Colors.white, size: 31),
                ),
              ],
            ),
          ),
          const SizedBox(height: RifinoSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(
                label: 'Audios',
                value: '${audios.length}',
                icon: Icons.volume_up_rounded,
                color: RifinoColors.primary,
              ),
              _StatChip(
                label: 'Mots',
                value: '${words.length}',
                icon: Icons.text_fields_rounded,
                color: RifinoColors.accentBlue,
              ),
              _StatChip(
                label: 'Leçons',
                value: '${lessons.length}',
                icon: Icons.school_rounded,
                color: RifinoColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (entries.isEmpty)
            const _EmptyState()
          else ...[
            if (audios.isNotEmpty) _SavedSection(title: 'Audios', entries: audios, onRemove: onRemove),
            if (words.isNotEmpty) _SavedSection(title: 'Mots', entries: words, onRemove: onRemove),
            if (lessons.isNotEmpty) _SavedSection(title: 'Leçons', entries: lessons, onRemove: onRemove),
          ],
        ],
      ),
    );
  }
}

class _SavedSection extends StatelessWidget {
  const _SavedSection({
    required this.title,
    required this.entries,
    required this.onRemove,
  });

  final String title;
  final List<SavedEntry> entries;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RifinoSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: RifinoSpacing.sm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
              child: _SavedRow(entry: entry, onRemove: onRemove),
            ),
        ],
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const _SavedRow({
    required this.entry,
    required this.onRemove,
  });

  final SavedEntry entry;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return RifinoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _colorForKind(entry.kind).withValues(alpha: 0.12),
            child: Icon(_iconForKind(entry.kind), color: _colorForKind(entry.kind)),
          ),
          const SizedBox(width: RifinoSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  entry.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RifinoColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Supprimer',
            onPressed: () => onRemove(entry.id),
            icon: const Icon(Icons.delete_outline_rounded),
            color: RifinoColors.danger,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const RifinoCard(
      padding: EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(Icons.bookmark_border_rounded, size: 38, color: RifinoColors.textSecondary),
          SizedBox(height: 10),
          Text('Rien ici pour le moment', style: TextStyle(fontWeight: FontWeight.w900)),
          SizedBox(height: 5),
          Text(
            'Garde tes audios, mots et leçons favoris ici.',
            textAlign: TextAlign.center,
            style: TextStyle(color: RifinoColors.textSecondary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RifinoRadius.pill),
        border: Border.all(color: RifinoColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: RifinoColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForKind(SavedEntryKind kind) {
  return switch (kind) {
    SavedEntryKind.audio => Icons.volume_up_outlined,
    SavedEntryKind.word => Icons.text_fields_rounded,
    SavedEntryKind.lesson => Icons.school_outlined,
  };
}

Color _colorForKind(SavedEntryKind kind) {
  return switch (kind) {
    SavedEntryKind.audio => RifinoColors.primary,
    SavedEntryKind.word => RifinoColors.accentBlue,
    SavedEntryKind.lesson => RifinoColors.accent,
  };
}
