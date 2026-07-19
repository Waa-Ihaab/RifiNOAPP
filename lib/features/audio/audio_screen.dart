import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';
import 'package:rifino/shared/models/saved_entry.dart';
import 'package:rifino/shared/widgets/rifino_card.dart';
import 'package:rifino/shared/widgets/rifino_top_bar.dart';

class AudioItem {
  const AudioItem({
    required this.title,
    required this.translation,
    required this.assetPath,
  });

  final String title;
  final String translation;
  final String assetPath;
}

const audioItems = [
  AudioItem(
    title: 'Nach',
    translation: 'moi',
    assetPath: 'audio/pronoms-personnels/Nach, moi.m4a',
  ),
  AudioItem(
    title: 'Chak',
    translation: 'toi',
    assetPath: 'audio/pronoms-personnels/Chak, toi.m4a',
  ),
  AudioItem(
    title: 'Netta',
    translation: 'il',
    assetPath: 'audio/pronoms-personnels/Il, netta.m4a',
  ),
  AudioItem(
    title: 'Nettath',
    translation: 'elle',
    assetPath: 'audio/pronoms-personnels/Elle, nettath.m4a',
  ),
  AudioItem(
    title: 'Nachin',
    translation: 'nous',
    assetPath: 'audio/pronoms-personnels/Nous, nachin.m4a',
  ),
  AudioItem(
    title: 'Kaniw',
    translation: 'vous',
    assetPath: 'audio/pronoms-personnels/Vous, kaniw.m4a',
  ),
  AudioItem(
    title: 'Nithni',
    translation: 'eux',
    assetPath: 'audio/pronoms-personnels/Eux, nithni.m4a',
  ),
  AudioItem(
    title: 'Takniya',
    translation: 'nom',
    assetPath: 'audio/pronoms-personnels/Nom, takniya.m4a',
  ),
  AudioItem(
    title: 'Issam',
    translation: 'prénom',
    assetPath: 'audio/pronoms-personnels/Prenom, issam.m4a',
  ),
  AudioItem(
    title: 'R3omwa',
    translation: 'âge',
    assetPath: 'audio/pronoms-personnels/Age, r3omwa.m4a',
  ),
  AudioItem(
    title: 'Doula',
    translation: 'pays',
    assetPath: 'audio/pronoms-personnels/Pays, doula.m4a',
  ),
  AudioItem(
    title: 'Abilaj',
    translation: 'ville',
    assetPath: 'audio/pronoms-personnels/Ville, abilaj.m4a',
  ),
];

class AudioScreen extends StatefulWidget {
  const AudioScreen({
    required this.onBack,
    required this.savedIds,
    required this.onToggleSaved,
    required this.onPractice,
    super.key,
  });

  final VoidCallback onBack;
  final Set<String> savedIds;
  final ValueChanged<SavedEntry> onToggleSaved;
  final VoidCallback onPractice;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioPlayer _player = AudioPlayer();
  String? _playingPath;

  @override
  void initState() {
    super.initState();
    _player.setVolume(1);
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _playingPath = null);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(AudioItem item) async {
    if (_playingPath == item.assetPath) {
      await _player.stop();
      setState(() => _playingPath = null);
      return;
    }

    setState(() => _playingPath = item.assetPath);
    widget.onPractice();
    await _player.stop();
    await _player.setVolume(1);
    await _player.play(AssetSource(item.assetPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RifinoTopBar(title: 'Audio', onBack: widget.onBack),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [RifinoColors.primary, Color(0xFF0A4B94)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio & Prononciation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Écoute les pronoms personnels et répète à voix haute.',
                        style: TextStyle(
                          color: Color(0xFFDCE8F7),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 29,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.volume_up_outlined, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: RifinoSpacing.lg),
          const Text(
            'Pronoms personnels',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: RifinoSpacing.md),
          for (final item in audioItems)
            Padding(
              padding: const EdgeInsets.only(bottom: RifinoSpacing.sm),
              child: _AudioRow(
                item: item,
                isPlaying: _playingPath == item.assetPath,
                saved: widget.savedIds.contains(_audioSavedId(item)),
                onPlay: () => _play(item),
                onToggleSaved: () {
                  widget.onToggleSaved(
                    SavedEntry(
                      id: _audioSavedId(item),
                      kind: SavedEntryKind.audio,
                      title: item.title,
                      subtitle: '${item.translation} - Pronoms personnels',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AudioRow extends StatelessWidget {
  const _AudioRow({
    required this.item,
    required this.isPlaying,
    required this.saved,
    required this.onPlay,
    required this.onToggleSaved,
  });

  final AudioItem item;
  final bool isPlaying;
  final bool saved;
  final VoidCallback onPlay;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return RifinoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(RifinoRadius.pill),
            child: CircleAvatar(
              backgroundColor: isPlaying
                  ? RifinoColors.accentBlue
                  : RifinoColors.accentBlue.withValues(alpha: 0.12),
              child: Icon(
                isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: isPlaying ? Colors.white : RifinoColors.accentBlue,
              ),
            ),
          ),
          const SizedBox(width: RifinoSpacing.md),
          Expanded(
            child: InkWell(
              onTap: onPlay,
              borderRadius: BorderRadius.circular(RifinoRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.translation,
                      style: const TextStyle(
                        color: RifinoColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onPlay,
            icon: Icon(
              isPlaying
                  ? Icons.stop_circle_outlined
                  : Icons.volume_up_outlined,
            ),
            color: RifinoColors.primary,
          ),
          IconButton(
            tooltip: saved ? 'Retirer' : 'Enregistrer',
            onPressed: onToggleSaved,
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
            color: saved ? RifinoColors.accentBlue : RifinoColors.purple,
          ),
        ],
      ),
    );
  }
}

String _audioSavedId(AudioItem item) {
  return 'audio:${item.assetPath}';
}
