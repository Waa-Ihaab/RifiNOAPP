import { Ionicons } from "@expo/vector-icons";
import {
  type AudioStatus,
  setAudioModeAsync,
  useAudioPlayer,
  useAudioPlayerStatus,
} from "expo-audio";
import { useEffect, useMemo, useState } from "react";
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import BottomTab from "@/app/BottomTab";
import TopBar from "@/app/TopBar";
import { useAppSettings } from "@/context/AppSettingsContext";
import { useSavedItems } from "@/context/SavedItemsContext";

type AudioItem = {
  id: string;
  fr: string;
  rif: string;
  source: number;
};

const AUDIO_ITEMS: AudioItem[] = [
  {
    id: "nach",
    fr: "moi",
    rif: "nach",
    source: require("../assets/audio/pronoms-personnels/Nach, moi.m4a"),
  },
  {
    id: "chak",
    fr: "toi",
    rif: "chak",
    source: require("../assets/audio/pronoms-personnels/Chak, toi.m4a"),
  },
  {
    id: "netta",
    fr: "il",
    rif: "netta",
    source: require("../assets/audio/pronoms-personnels/Il, netta.m4a"),
  },
  {
    id: "nettath",
    fr: "elle",
    rif: "nettath",
    source: require("../assets/audio/pronoms-personnels/Elle, nettath.m4a"),
  },
  {
    id: "nachin",
    fr: "nous",
    rif: "nachin",
    source: require("../assets/audio/pronoms-personnels/Nous, nachin.m4a"),
  },
  {
    id: "kaniw",
    fr: "vous",
    rif: "kaniw",
    source: require("../assets/audio/pronoms-personnels/Vous, kaniw.m4a"),
  },
  {
    id: "nithni",
    fr: "eux",
    rif: "nithni",
    source: require("../assets/audio/pronoms-personnels/Eux, nithni.m4a"),
  },
  {
    id: "takniya",
    fr: "nom",
    rif: "takniya",
    source: require("../assets/audio/pronoms-personnels/Nom, takniya.m4a"),
  },
  {
    id: "issam",
    fr: "prénom",
    rif: "issam",
    source: require("../assets/audio/pronoms-personnels/Prenom, issam.m4a"),
  },
  {
    id: "r3omwa",
    fr: "âge",
    rif: "r3omwa",
    source: require("../assets/audio/pronoms-personnels/Age, r3omwa.m4a"),
  },
  {
    id: "doula",
    fr: "pays",
    rif: "doula",
    source: require("../assets/audio/pronoms-personnels/Pays, doula.m4a"),
  },
  {
    id: "abilaj",
    fr: "ville",
    rif: "abilaj",
    source: require("../assets/audio/pronoms-personnels/Ville, abilaj.m4a"),
  },
];

export default function AudioScreen() {
  const [query, setQuery] = useState("");
  const [activeId, setActiveId] = useState(AUDIO_ITEMS[0].id);
  const [playSignal, setPlaySignal] = useState(0);
  const [activeStatus, setActiveStatus] = useState<AudioStatus | null>(null);
  const { theme } = useAppSettings();
  const { isAudioSaved, toggleAudio } = useSavedItems();

  const activeItem =
    AUDIO_ITEMS.find((item) => item.id === activeId) ?? AUDIO_ITEMS[0];

  const filteredItems = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    if (!normalizedQuery) {
      return AUDIO_ITEMS;
    }

    return AUDIO_ITEMS.filter((item) =>
      `${item.fr} ${item.rif}`.toLowerCase().includes(normalizedQuery)
    );
  }, [query]);

  const progress =
    activeStatus && activeStatus.duration > 0
      ? Math.min(activeStatus.currentTime / activeStatus.duration, 1)
      : 0;

  useEffect(() => {
    setAudioModeAsync({
      playsInSilentMode: true,
      interruptionMode: "duckOthers",
    }).catch(() => undefined);
  }, []);

  function toggleActivePlayback() {
    setPlaySignal((value) => value + 1);
  }

  return (
    <SafeAreaView
      style={[styles.container, { backgroundColor: theme.background }]}
    >
      <TopBar title="Audio" />

      <ScrollView
        contentContainerStyle={styles.content}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.hero}>
          <View style={styles.heroText}>
            <Text style={styles.heroEyebrow}>Pronoms personnels</Text>
            <Text style={styles.heroTitle}>Écoute et répète</Text>
            <Text style={styles.heroSubtitle}>
              {AUDIO_ITEMS.length} audios courts pour travailler la
              prononciation.
            </Text>
          </View>

          <Pressable
            accessibilityRole="button"
            onPress={toggleActivePlayback}
            style={styles.heroButton}
          >
            <Ionicons
              name={activeStatus?.playing ? "pause" : "play"}
              size={30}
              color="#FFFFFF"
            />
          </Pressable>
        </View>

        <View
          style={[
            styles.nowPlaying,
            { backgroundColor: theme.surface, borderColor: theme.border },
          ]}
        >
          <View>
            <Text style={[styles.nowLabel, { color: theme.muted }]}>
              Lecture
            </Text>
            <Text style={[styles.nowWord, { color: theme.accent }]}>
              {activeItem.rif}
            </Text>
            <Text style={[styles.nowTranslation, { color: theme.text }]}>
              {activeItem.fr}
            </Text>
          </View>

          <Text style={styles.timer}>
            {formatTime(activeStatus?.currentTime ?? 0)} /{" "}
            {formatTime(activeStatus?.duration ?? 0)}
          </Text>
        </View>

        <View style={styles.progressTrack}>
          <View style={[styles.progressFill, { width: `${progress * 100}%` }]} />
        </View>

        <View
          style={[
            styles.searchBox,
            { backgroundColor: theme.card, borderColor: theme.border },
          ]}
        >
          <Ionicons name="search-outline" size={20} color={theme.muted} />
          <TextInput
            value={query}
            onChangeText={setQuery}
            placeholder="Rechercher un audio"
            placeholderTextColor={theme.muted}
            style={[styles.searchInput, { color: theme.text }]}
          />
          {query.length > 0 && (
            <Pressable
              accessibilityRole="button"
              onPress={() => setQuery("")}
              style={styles.clearButton}
            >
              <Ionicons name="close-circle" size={20} color={theme.muted} />
            </Pressable>
          )}
        </View>

        <View style={styles.sectionHeader}>
          <Text style={[styles.sectionTitle, { color: theme.text }]}>
            Liste des audios
          </Text>
          <Text style={styles.sectionCount}>
            {filteredItems.length} résultat
            {filteredItems.length > 1 ? "s" : ""}
          </Text>
        </View>

        {filteredItems.map((item) => (
          <AudioRow
            key={item.id}
            item={item}
            isActive={activeId === item.id}
            playSignal={playSignal}
            onActivate={() => setActiveId(item.id)}
            onStatusChange={setActiveStatus}
            isSaved={isAudioSaved(item.id)}
            onToggleSave={() =>
              toggleAudio({
                id: item.id,
                title: item.rif,
                translation: item.fr,
                section: "Pronoms personnels",
              })
            }
            theme={theme}
          />
        ))}

        {filteredItems.length === 0 && (
          <View
            style={[
              styles.emptyState,
              { backgroundColor: theme.surface, borderColor: theme.border },
            ]}
          >
            <Ionicons name="search-outline" size={28} color={theme.muted} />
            <Text style={[styles.emptyTitle, { color: theme.text }]}>
              Aucun audio trouvé
            </Text>
            <Text style={[styles.emptyText, { color: theme.muted }]}>
              Essaie avec le mot en français ou en rifain.
            </Text>
          </View>
        )}
      </ScrollView>

      <BottomTab />
    </SafeAreaView>
  );
}

function AudioRow({
  item,
  isActive,
  playSignal,
  onActivate,
  onStatusChange,
  isSaved,
  onToggleSave,
  theme,
}: {
  item: AudioItem;
  isActive: boolean;
  playSignal: number;
  onActivate: () => void;
  onStatusChange: (status: AudioStatus) => void;
  isSaved: boolean;
  onToggleSave: () => void;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
    accent: string;
  };
}) {
  const player = useAudioPlayer(item.source, { updateInterval: 120 });
  const status = useAudioPlayerStatus(player);

  useEffect(() => {
    if (!isActive && status.playing) {
      player.pause();
    }
  }, [isActive, player, status.playing]);

  useEffect(() => {
    if (isActive) {
      onStatusChange(status);
    }
  }, [isActive, onStatusChange, status]);

  useEffect(() => {
    if (!isActive || playSignal === 0) {
      return;
    }

    togglePlayback();
  }, [playSignal]);

  function togglePlayback() {
    if (status.playing) {
      player.pause();
      return;
    }

    if (status.didJustFinish) {
      player.seekTo(0).catch(() => undefined);
    }

    player.play();
  }

  function handlePress() {
    if (!isActive) {
      onActivate();
    }

    togglePlayback();
  }

  return (
    <Pressable
      accessibilityRole="button"
      onPress={handlePress}
      style={[
        styles.audioCard,
        { backgroundColor: theme.card, borderColor: theme.border },
        isActive && styles.activeAudioCard,
      ]}
    >
      <View style={[styles.playBadge, isActive && styles.activeBadge]}>
        <Ionicons
          name={isActive && status.playing ? "pause" : "play"}
          size={20}
          color={isActive ? "#FFFFFF" : theme.accent}
        />
      </View>

      <View style={styles.audioText}>
        <Text style={[styles.rifWord, { color: theme.accent }]}>
          {item.rif}
        </Text>
        <Text style={[styles.frenchWord, { color: theme.muted }]}>
          {item.fr}
        </Text>
      </View>

      <Pressable
        accessibilityRole="button"
        onPress={(event) => {
          event.stopPropagation();
          onToggleSave();
        }}
        style={styles.saveButton}
      >
        <Ionicons
          name={isSaved ? "bookmark" : "bookmark-outline"}
          size={22}
          color={isSaved ? theme.accent : "#9A96C0"}
        />
      </Pressable>
    </Pressable>
  );
}

function formatTime(seconds: number) {
  if (!Number.isFinite(seconds) || seconds <= 0) {
    return "0:00";
  }

  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60)
    .toString()
    .padStart(2, "0");

  return `${minutes}:${remainingSeconds}`;
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
  },

  content: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 86,
  },

  hero: {
    minHeight: 142,
    borderRadius: 8,
    backgroundColor: "#111111",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 18,
    paddingVertical: 18,
  },

  heroText: {
    flex: 1,
    paddingRight: 16,
  },

  heroEyebrow: {
    color: "#9A96C0",
    fontSize: 12,
    fontWeight: "900",
    textTransform: "uppercase",
  },

  heroTitle: {
    marginTop: 8,
    color: "#FFFFFF",
    fontSize: 25,
    fontWeight: "900",
  },

  heroSubtitle: {
    marginTop: 7,
    color: "#D8D8E0",
    fontSize: 13,
    fontWeight: "700",
    lineHeight: 18,
  },

  heroButton: {
    width: 62,
    height: 62,
    borderRadius: 31,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
  },

  nowPlaying: {
    marginTop: 16,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#F8F8FA",
    padding: 14,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },

  nowLabel: {
    color: "#777777",
    fontSize: 11,
    fontWeight: "900",
    textTransform: "uppercase",
  },

  nowWord: {
    marginTop: 5,
    color: "#002F63",
    fontSize: 21,
    fontWeight: "900",
  },

  nowTranslation: {
    marginTop: 2,
    color: "#111111",
    fontSize: 13,
    fontWeight: "800",
  },

  timer: {
    color: "#7B78A8",
    fontSize: 12,
    fontWeight: "900",
  },

  progressTrack: {
    height: 6,
    borderRadius: 3,
    marginTop: 10,
    backgroundColor: "#E6E6EC",
    overflow: "hidden",
  },

  progressFill: {
    height: "100%",
    borderRadius: 3,
    backgroundColor: "#0A84FF",
  },

  searchBox: {
    height: 48,
    borderWidth: 1,
    borderColor: "#D8D8E0",
    borderRadius: 8,
    marginTop: 18,
    paddingHorizontal: 12,
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#FFFFFF",
  },

  searchInput: {
    flex: 1,
    height: "100%",
    marginLeft: 8,
    color: "#111111",
    fontSize: 15,
    fontWeight: "700",
  },

  clearButton: {
    width: 32,
    height: 32,
    alignItems: "center",
    justifyContent: "center",
  },

  sectionHeader: {
    marginTop: 22,
    marginBottom: 10,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },

  sectionTitle: {
    color: "#000000",
    fontSize: 16,
    fontWeight: "900",
  },

  sectionCount: {
    color: "#7B78A8",
    fontSize: 12,
    fontWeight: "900",
  },

  audioCard: {
    minHeight: 68,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    marginBottom: 10,
  },

  activeAudioCard: {
    borderColor: "#0A84FF",
  },

  playBadge: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#EAF3FF",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 12,
  },

  activeBadge: {
    backgroundColor: "#0A84FF",
  },

  audioText: {
    flex: 1,
  },

  saveButton: {
    width: 42,
    height: 42,
    alignItems: "center",
    justifyContent: "center",
  },

  rifWord: {
    color: "#002F63",
    fontSize: 17,
    fontWeight: "900",
  },

  frenchWord: {
    marginTop: 3,
    color: "#777777",
    fontSize: 13,
    fontWeight: "800",
  },

  emptyState: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    paddingVertical: 28,
    paddingHorizontal: 18,
    alignItems: "center",
    backgroundColor: "#F8F8FA",
  },

  emptyTitle: {
    marginTop: 8,
    color: "#111111",
    fontSize: 16,
    fontWeight: "900",
  },

  emptyText: {
    marginTop: 4,
    color: "#777777",
    fontSize: 13,
    fontWeight: "700",
    textAlign: "center",
  },
});
