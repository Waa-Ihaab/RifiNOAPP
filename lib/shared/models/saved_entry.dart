enum SavedEntryKind {
  audio,
  word,
  lesson,
}

class SavedEntry {
  const SavedEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final SavedEntryKind kind;
  final String title;
  final String subtitle;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'title': title,
      'subtitle': subtitle,
    };
  }

  static SavedEntry? fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final kindName = json['kind'];
    final title = json['title'];
    final subtitle = json['subtitle'];

    if (id is! String || kindName is! String || title is! String || subtitle is! String) {
      return null;
    }

    SavedEntryKind? kind;
    for (final item in SavedEntryKind.values) {
      if (item.name == kindName) {
        kind = item;
        break;
      }
    }
    if (kind == null) return null;

    return SavedEntry(
      id: id,
      kind: kind,
      title: title,
      subtitle: subtitle,
    );
  }
}
