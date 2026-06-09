import { Ionicons } from "@expo/vector-icons";
import { useFocusEffect } from "@react-navigation/native";
import { router } from "expo-router";
import { useCallback, useMemo, useState } from "react";
import { Pressable, ScrollView, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import TopBar from "@/app/TopBar";
import { useSavedItems } from "@/context/SavedItemsContext";
import {
  finishedLessonIds,
  RifianLesson,
  RIFIAN_LESSONS,
} from "@/constants/rifianLessons";

export default function LeconsScreen() {
  const [activeLessonId, setActiveLessonId] = useState(RIFIAN_LESSONS[0].id);
  const [finishedLessons, setFinishedLessons] = useState<string[]>([
    ...finishedLessonIds,
  ]);
  const { isLessonSaved, toggleLesson: toggleSavedLesson } = useSavedItems();

  useFocusEffect(
    useCallback(() => {
      setFinishedLessons([...finishedLessonIds]);
    }, [])
  );

  const finishedCount = finishedLessons.length;
  const progressText = useMemo(
    () => `${finishedCount}/${RIFIAN_LESSONS.length} lecons finies`,
    [finishedCount]
  );

  function toggleLesson(lessonId: string) {
    setActiveLessonId((currentLessonId) =>
      currentLessonId === lessonId ? "" : lessonId
    );
  }

  function openLesson(lessonId: string) {
    router.push({
      pathname: "/lecon-detail",
      params: { id: lessonId },
    });
  }

  return (
    <SafeAreaView style={styles.container}>
      <TopBar title="Leçons" />

      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.summaryCard}>
          <View>
            <Text style={styles.pageTitle}>Mes leçons</Text>
          </View>

          <View style={styles.progressBadge}>
            <Ionicons name="checkmark-circle" size={16} color="#34B34A" />
            <Text style={styles.progressText}>{progressText}</Text>
          </View>
        </View>

        {RIFIAN_LESSONS.map((lesson, index) => {
          const isActive = activeLessonId === lesson.id;
          const isFinished = finishedLessons.includes(lesson.id);

          return (
            <LessonCard
              key={lesson.id}
              index={index}
              lesson={lesson}
              isActive={isActive}
              isFinished={isFinished}
              isSaved={isLessonSaved(lesson.id)}
              onToggle={() => toggleLesson(lesson.id)}
              onToggleSave={() =>
                toggleSavedLesson({
                  id: lesson.id,
                  title: lesson.title,
                  level: lesson.level,
                  description: lesson.description,
                })
              }
              onOpen={() => openLesson(lesson.id)}
            />
          );
        })}
      </ScrollView>
    </SafeAreaView>
  );
}

function LessonCard({
  index,
  lesson,
  isActive,
  isFinished,
  isSaved,
  onToggle,
  onToggleSave,
  onOpen,
}: {
  index: number;
  lesson: RifianLesson;
  isActive: boolean;
  isFinished: boolean;
  isSaved: boolean;
  onToggle: () => void;
  onToggleSave: () => void;
  onOpen: () => void;
}) {
  return (
    <View style={styles.lessonCard}>
      <Pressable
        accessibilityRole="button"
        style={styles.lessonHeader}
        onPress={onToggle}
      >
        <View style={[styles.lessonNumber, isFinished && styles.finishedIcon]}>
          {isFinished ? (
            <Ionicons name="checkmark" size={18} color="#FFFFFF" />
          ) : (
            <Text style={styles.lessonNumberText}>{index + 1}</Text>
          )}
        </View>

        <View style={styles.lessonInfo}>
          <Text style={styles.smallText}>{lesson.level}</Text>
          <Text style={styles.lessonTitle}>{lesson.title}</Text>
          <Text style={styles.lessonDescription}>{lesson.description}</Text>
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
            color={isSaved ? "#007AFF" : "#7B78A8"}
          />
        </Pressable>

        <Ionicons
          name={isActive ? "chevron-up" : "chevron-down"}
          size={24}
          color="#007AFF"
        />
      </Pressable>

      {isActive && (
        <View style={styles.lessonBody}>
          {lesson.vocabulary.slice(0, 2).map((item) => (
            <View key={item} style={styles.vocabularyRow}>
              <Ionicons name="volume-high-outline" size={18} color="#7B78A8" />
              <Text style={styles.vocabularyText}>{item}</Text>
            </View>
          ))}

          <Pressable
            accessibilityRole="button"
            style={[styles.primaryButton, isFinished && styles.finishedButton]}
            onPress={onOpen}
          >
            <Ionicons name="enter-outline" size={18} color="#FFFFFF" />
            <Text style={styles.primaryButtonText}>
              {isFinished ? "Revoir le cours" : "Entrer dans le cours"}
            </Text>
          </Pressable>
        </View>
      )}
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

  summaryCard: {
    backgroundColor: "#007AFF",
    borderRadius: 7,
    padding: 14,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    gap: 12,
  },

  pageTitle: {
    marginTop: 2,
    fontSize: 18,
    fontWeight: "800",
    color: "#ffffff",
  },

  progressBadge: {
    flexDirection: "row",
    alignItems: "center",
    gap: 5,
    backgroundColor: "#FFFFFF",
    borderRadius: 5,
    paddingVertical: 6,
    paddingHorizontal: 9,
  },

  progressText: {
    fontSize: 11,
    fontWeight: "800",
    color: "#202020",
  },

  lessonCard: {
    backgroundColor: "#F0F0F5",
    borderRadius: 7,
    padding: 14,
  },

  lessonHeader: {
    flexDirection: "row",
    alignItems: "center",
    gap: 12,
  },

  lessonNumber: {
    width: 34,
    height: 34,
    borderRadius: 9,
    backgroundColor: "#202020",
    justifyContent: "center",
    alignItems: "center",
  },

  finishedIcon: {
    backgroundColor: "#34B34A",
  },

  lessonNumberText: {
    color: "#FFFFFF",
    fontWeight: "800",
  },

  lessonInfo: {
    flex: 1,
  },

  saveButton: {
    width: 34,
    height: 34,
    alignItems: "center",
    justifyContent: "center",
  },

  smallText: {
    color: "#007AFF",
    fontSize: 10,
    fontWeight: "700",
  },

  lessonTitle: {
    marginTop: 2,
    fontSize: 15,
    fontWeight: "800",
    color: "#000000",
  },

  lessonDescription: {
    marginTop: 4,
    fontSize: 12,
    lineHeight: 17,
    color: "#444444",
  },

  lessonBody: {
    marginTop: 14,
    paddingTop: 12,
    borderTopWidth: 1,
    borderTopColor: "#D8D8E0",
    gap: 10,
  },

  vocabularyRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },

  vocabularyText: {
    fontSize: 13,
    fontWeight: "700",
    color: "#202020",
  },

  primaryButton: {
    height: 34,
    backgroundColor: "#34B34A",
    borderRadius: 5,
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    gap: 6,
    marginTop: 4,
  },

  finishedButton: {
    backgroundColor: "#007AFF",
  },

  primaryButtonText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },
});
