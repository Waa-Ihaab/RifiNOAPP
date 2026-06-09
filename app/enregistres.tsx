import { Ionicons } from "@expo/vector-icons";
import { router } from "expo-router";
import { useRef, useState } from "react";
import {
  Animated,
  PanResponder,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import BottomTab from "@/app/BottomTab";
import TopBar from "@/app/TopBar";
import { useAppSettings } from "@/context/AppSettingsContext";
import { useSavedItems } from "@/context/SavedItemsContext";

type SavedTab = "audios" | "mots" | "lecons";

const TABS: {
  id: SavedTab;
  label: string;
  icon: keyof typeof Ionicons.glyphMap;
}[] = [
  { id: "audios", label: "Audios", icon: "volume-high-outline" },
  { id: "mots", label: "Mots", icon: "bookmark-outline" },
  { id: "lecons", label: "Lecons", icon: "school-outline" },
];

export default function EnregistresScreen() {
  const [activeTab, setActiveTab] = useState<SavedTab>("audios");
  const { theme } = useAppSettings();
  const {
    audios,
    words,
    lessons,
    removeAudio,
    removeWord,
    removeLesson,
  } = useSavedItems();

  const totalSaved = audios.length + words.length + lessons.length;
  const activeCount =
    activeTab === "audios"
      ? audios.length
      : activeTab === "mots"
        ? words.length
        : lessons.length;

  return (
    <SafeAreaView
      style={[styles.container, { backgroundColor: theme.background }]}
    >
      <TopBar title="Enregistres" />

      <ScrollView
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.hero}>
          <View style={styles.heroCopy}>
            <Text style={styles.heroEyebrow}>Mes favoris</Text>
            <Text style={styles.heroTitle}>Tout ce que tu gardes</Text>
            <Text style={styles.heroSubtitle}>
              Audios, mots et lecons retrouves au meme endroit.
            </Text>
          </View>

          <View style={styles.heroIcon}>
            <Ionicons name="bookmark" size={30} color="#FFFFFF" />
          </View>
        </View>

        <View style={styles.statsRow}>
          <StatCard
            label="Audios"
            value={audios.length}
            icon="volume-high-outline"
            theme={theme}
          />
          <StatCard
            label="Mots"
            value={words.length}
            icon="text-outline"
            theme={theme}
          />
          <StatCard
            label="Lecons"
            value={lessons.length}
            icon="school-outline"
            theme={theme}
          />
        </View>

        <View style={[styles.tabs, { borderColor: theme.border }]}>
          {TABS.map((tab) => {
            const isActive = activeTab === tab.id;

            return (
              <Pressable
                key={tab.id}
                accessibilityRole="button"
                onPress={() => setActiveTab(tab.id)}
                style={[styles.tabButton, isActive && styles.activeTabButton]}
              >
                <Ionicons
                  name={tab.icon}
                  size={18}
                  color={isActive ? "#FFFFFF" : theme.muted}
                />
                <Text
                  style={[
                    styles.tabText,
                    { color: theme.muted },
                    isActive && styles.activeTabText,
                  ]}
                >
                  {tab.label}
                </Text>
              </Pressable>
            );
          })}
        </View>

        <View style={styles.sectionHeader}>
          <Text style={[styles.sectionTitle, { color: theme.text }]}>
            {activeCount} element{activeCount > 1 ? "s" : ""}
          </Text>
          <Text style={[styles.sectionMeta, { color: theme.muted }]}>
            {totalSaved} au total
          </Text>
        </View>

        {activeTab === "audios" &&
          audios.map((audio) => (
            <SwipeToDelete key={audio.id} onDelete={() => removeAudio(audio.id)}>
              <SavedRow
                icon="play"
                title={audio.title}
                subtitle={`${audio.translation} - ${audio.section}`}
                actionLabel="Ecouter"
                onPress={() => router.push("/audio")}
                theme={theme}
              />
            </SwipeToDelete>
          ))}

        {activeTab === "mots" &&
          words.map((word) => (
            <SwipeToDelete key={word.id} onDelete={() => removeWord(word.id)}>
              <SavedRow
                icon="book-outline"
                title={word.rif}
                subtitle={`${word.fr} - ${word.category}`}
                actionLabel="Voir"
                onPress={() =>
                  router.push({
                    pathname: "/dictionnaire",
                    params: { category: word.category },
                  })
                }
                theme={theme}
              />
            </SwipeToDelete>
          ))}

        {activeTab === "lecons" &&
          lessons.map((lesson) => (
            <SwipeToDelete
              key={lesson.id}
              onDelete={() => removeLesson(lesson.id)}
            >
              <SavedRow
                icon="school-outline"
                title={lesson.title}
                subtitle={`${lesson.level} - ${lesson.description}`}
                actionLabel="Ouvrir"
                onPress={() =>
                  router.push({
                    pathname: "/lecon-detail",
                    params: { id: lesson.id },
                  })
                }
                theme={theme}
              />
            </SwipeToDelete>
          ))}

        {activeCount === 0 && (
          <View
            style={[
              styles.emptyState,
              { backgroundColor: theme.card, borderColor: theme.border },
            ]}
          >
            <Ionicons name="bookmark-outline" size={30} color={theme.muted} />
            <Text style={[styles.emptyTitle, { color: theme.text }]}>
              Rien ici pour le moment
            </Text>
            <Text style={[styles.emptyText, { color: theme.muted }]}>
              Appuie sur une icone save dans application pour ajouter un element.
            </Text>
          </View>
        )}
      </ScrollView>

      <BottomTab />
    </SafeAreaView>
  );
}

function SwipeToDelete({
  children,
  onDelete,
}: {
  children: React.ReactNode;
  onDelete: () => void;
}) {
  const translateX = useRef(new Animated.Value(0)).current;
  const hasDeleted = useRef(false);

  const panResponder = useRef(
    PanResponder.create({
      onMoveShouldSetPanResponder: (_, gestureState) =>
        Math.abs(gestureState.dx) > 12 && Math.abs(gestureState.dy) < 12,
      onPanResponderMove: (_, gestureState) => {
        if (gestureState.dx < 0) {
          translateX.setValue(Math.max(gestureState.dx, -112));
        }
      },
      onPanResponderRelease: (_, gestureState) => {
        if (gestureState.dx < -86 && !hasDeleted.current) {
          hasDeleted.current = true;
          Animated.timing(translateX, {
            toValue: -420,
            duration: 160,
            useNativeDriver: true,
          }).start(onDelete);
          return;
        }

        Animated.spring(translateX, {
          toValue: 0,
          useNativeDriver: true,
        }).start();
      },
    })
  ).current;

  return (
    <View style={styles.swipeWrap}>
      <View style={styles.deleteBackground}>
        <Ionicons name="trash-outline" size={22} color="#FFFFFF" />
        <Text style={styles.deleteText}>Supprimer</Text>
      </View>

      <Animated.View
        {...panResponder.panHandlers}
        style={{ transform: [{ translateX }] }}
      >
        {children}
      </Animated.View>
    </View>
  );
}

function StatCard({
  label,
  value,
  icon,
  theme,
}: {
  label: string;
  value: number;
  icon: keyof typeof Ionicons.glyphMap;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
  };
}) {
  return (
    <View
      style={[
        styles.statCard,
        { backgroundColor: theme.card, borderColor: theme.border },
      ]}
    >
      <Ionicons name={icon} size={20} color="#0A84FF" />
      <Text style={[styles.statValue, { color: theme.text }]}>{value}</Text>
      <Text style={[styles.statLabel, { color: theme.muted }]}>{label}</Text>
    </View>
  );
}

function SavedRow({
  icon,
  title,
  subtitle,
  actionLabel,
  onPress,
  theme,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  title: string;
  subtitle: string;
  actionLabel: string;
  onPress: () => void;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
    accent: string;
  };
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={[
        styles.savedRow,
        { backgroundColor: theme.card, borderColor: theme.border },
      ]}
    >
      <View style={styles.rowIcon}>
        <Ionicons name={icon} size={20} color="#FFFFFF" />
      </View>

      <View style={styles.rowText}>
        <Text style={[styles.rowTitle, { color: theme.text }]}>{title}</Text>
        <Text
          numberOfLines={2}
          style={[styles.rowSubtitle, { color: theme.muted }]}
        >
          {subtitle}
        </Text>
      </View>

      <View style={styles.rowAction}>
        <Text style={[styles.rowActionText, { color: theme.accent }]}>
          {actionLabel}
        </Text>
        <Ionicons name="chevron-forward" size={18} color={theme.accent} />
      </View>
    </Pressable>
  );
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
    minHeight: 132,
    borderRadius: 8,
    backgroundColor: "#202020",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 18,
    paddingVertical: 18,
  },

  heroCopy: {
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
    fontSize: 24,
    fontWeight: "900",
  },

  heroSubtitle: {
    marginTop: 7,
    color: "#D8D8E0",
    fontSize: 13,
    fontWeight: "700",
    lineHeight: 18,
  },

  heroIcon: {
    width: 58,
    height: 58,
    borderRadius: 29,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
  },

  statsRow: {
    flexDirection: "row",
    gap: 10,
    marginTop: 14,
  },

  statCard: {
    flex: 1,
    minHeight: 86,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    alignItems: "center",
    justifyContent: "center",
    padding: 10,
  },

  statValue: {
    marginTop: 5,
    color: "#111111",
    fontSize: 20,
    fontWeight: "900",
  },

  statLabel: {
    marginTop: 2,
    color: "#777777",
    fontSize: 11,
    fontWeight: "800",
  },

  tabs: {
    minHeight: 48,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    flexDirection: "row",
    marginTop: 16,
    padding: 4,
    gap: 4,
  },

  tabButton: {
    flex: 1,
    borderRadius: 6,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 5,
  },

  activeTabButton: {
    backgroundColor: "#0A84FF",
  },

  tabText: {
    color: "#777777",
    fontSize: 12,
    fontWeight: "900",
  },

  activeTabText: {
    color: "#FFFFFF",
  },

  sectionHeader: {
    marginTop: 22,
    marginBottom: 10,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },

  sectionTitle: {
    color: "#111111",
    fontSize: 16,
    fontWeight: "900",
  },

  sectionMeta: {
    color: "#777777",
    fontSize: 12,
    fontWeight: "800",
  },

  swipeWrap: {
    marginBottom: 10,
  },

  deleteBackground: {
    ...StyleSheet.absoluteFillObject,
    borderRadius: 8,
    backgroundColor: "#B3262E",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "flex-end",
    gap: 7,
    paddingRight: 18,
    marginBottom: 10,
  },

  deleteText: {
    color: "#FFFFFF",
    fontSize: 12,
    fontWeight: "900",
  },

  savedRow: {
    minHeight: 74,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    paddingVertical: 10,
  },

  rowIcon: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 12,
  },

  rowText: {
    flex: 1,
    paddingRight: 10,
  },

  rowTitle: {
    color: "#111111",
    fontSize: 16,
    fontWeight: "900",
  },

  rowSubtitle: {
    marginTop: 3,
    color: "#777777",
    fontSize: 12,
    fontWeight: "700",
    lineHeight: 16,
  },

  rowAction: {
    minWidth: 72,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "flex-end",
  },

  rowActionText: {
    color: "#0A84FF",
    fontSize: 12,
    fontWeight: "900",
  },

  emptyState: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    paddingVertical: 28,
    paddingHorizontal: 18,
    alignItems: "center",
    backgroundColor: "#FFFFFF",
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
    lineHeight: 18,
  },
});
