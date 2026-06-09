import { Ionicons } from "@expo/vector-icons";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect } from "react";
import { ScrollView, StyleSheet, Text, View, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import TopBar from "@/app/TopBar";
import { useSavedItems } from "@/context/SavedItemsContext";
import { rememberLessonForNotifications } from "@/services/learningNotifications";
import {
  finishedLessonIds,
  getRifianLessonById,
} from "@/constants/rifianLessons";

export default function LeconDetailScreen() {
  const { id } = useLocalSearchParams<{ id?: string }>();
  const lesson = getRifianLessonById(id ?? "");
  const { isLessonSaved, toggleLesson } = useSavedItems();

  useEffect(() => {
    if (lesson) {
      rememberLessonForNotifications(lesson.title).catch(() => undefined);
    }
  }, [lesson]);

  function finishLesson() {
    if (!lesson) {
      return;
    }

    finishedLessonIds.add(lesson.id);
    router.back();
  }

  if (!lesson) {
    return (
      <SafeAreaView style={styles.container}>
        <TopBar title="Cours" />
        <View style={styles.emptyState}>
          <Ionicons name="alert-circle-outline" size={34} color="#B3262E" />
          <Text style={styles.emptyTitle}>Cours introuvable</Text>
        </View>
      </SafeAreaView>
    );
  }

  const isFinished = finishedLessonIds.has(lesson.id);
  const isSaved = isLessonSaved(lesson.id);

  return (
    <SafeAreaView style={styles.container}>
      <TopBar title={lesson.title} />

      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.heroCard}>
          <View style={styles.heroHeader}>
            <View style={styles.heroTitleBlock}>
              <Text style={styles.smallText}>{lesson.level}</Text>
              <Text style={styles.pageTitle}>{lesson.title}</Text>
            </View>

            <Pressable
              accessibilityRole="button"
              onPress={() =>
                toggleLesson({
                  id: lesson.id,
                  title: lesson.title,
                  level: lesson.level,
                  description: lesson.description,
                })
              }
              style={styles.saveButton}
            >
              <Ionicons
                name={isSaved ? "bookmark" : "bookmark-outline"}
                size={24}
                color={isSaved ? "#007AFF" : "#7B78A8"}
              />
            </Pressable>
          </View>
          <Text style={styles.description}>{lesson.description}</Text>
        </View>

        <LessonBlock title="Mots a apprendre" icon="book-outline">
          {lesson.vocabulary.map((item) => (
            <LearningRow key={item} text={item} />
          ))}
        </LessonBlock>

        <LessonBlock title="Phrases du cours" icon="chatbubble-outline">
          {lesson.phrases.map((phrase) => (
            <LearningRow key={phrase} text={phrase} />
          ))}
        </LessonBlock>

        <Pressable
          accessibilityRole="button"
          style={[styles.primaryButton, isFinished && styles.finishedButton]}
          onPress={finishLesson}
        >
          <Ionicons
            name={isFinished ? "checkmark-circle" : "flag-outline"}
            size={18}
            color="#FFFFFF"
          />
          <Text style={styles.primaryButtonText}>
            {isFinished ? "Cours deja fini" : "Terminer ce cours"}
          </Text>
        </Pressable>
      </ScrollView>
    </SafeAreaView>
  );
}

function LessonBlock({
  title,
  icon,
  children,
}: {
  title: string;
  icon: keyof typeof Ionicons.glyphMap;
  children: React.ReactNode;
}) {
  return (
    <View style={styles.blockCard}>
      <View style={styles.blockHeader}>
        <Ionicons name={icon} size={18} color="#7B78A8" />
        <Text style={styles.blockTitle}>{title}</Text>
      </View>

      <View style={styles.blockContent}>{children}</View>
    </View>
  );
}

function LearningRow({ text }: { text: string }) {
  return (
    <View style={styles.learningRow}>
      <Ionicons name="volume-high-outline" size={18} color="#7B78A8" />
      <Text style={styles.learningText}>{text}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
  },

  scroll: {
    flex: 1,
  },

  content: {
    paddingHorizontal: 22,
    paddingTop: 18,
    paddingBottom: 28,
    gap: 14,
  },

  heroCard: {
    backgroundColor: "#F0F0F5",
    borderRadius: 7,
    padding: 14,
  },

  heroHeader: {
    flexDirection: "row",
    alignItems: "flex-start",
    justifyContent: "space-between",
    gap: 12,
  },

  heroTitleBlock: {
    flex: 1,
  },

  saveButton: {
    width: 40,
    height: 40,
    alignItems: "center",
    justifyContent: "center",
  },

  smallText: {
    color: "#7B78A8",
    fontSize: 10,
    fontWeight: "700",
  },

  pageTitle: {
    marginTop: 2,
    fontSize: 20,
    fontWeight: "800",
    color: "#000000",
  },

  description: {
    marginTop: 8,
    fontSize: 13,
    lineHeight: 19,
    color: "#444444",
  },

  blockCard: {
    backgroundColor: "#F0F0F5",
    borderRadius: 7,
    padding: 14,
  },

  blockHeader: {
    flexDirection: "row",
    alignItems: "center",
    gap: 7,
  },

  blockTitle: {
    fontSize: 15,
    fontWeight: "800",
    color: "#000000",
  },

  blockContent: {
    marginTop: 12,
    gap: 10,
  },

  learningRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },

  learningText: {
    flex: 1,
    fontSize: 13,
    fontWeight: "700",
    color: "#202020",
  },

  primaryButton: {
    height: 38,
    backgroundColor: "#34B34A",
    borderRadius: 5,
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    gap: 6,
  },

  finishedButton: {
    backgroundColor: "#007AFF",
  },

  primaryButtonText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },

  emptyState: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    gap: 8,
  },

  emptyTitle: {
    fontSize: 16,
    fontWeight: "800",
    color: "#000000",
  },
});
