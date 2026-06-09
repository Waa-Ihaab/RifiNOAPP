import { Ionicons } from "@expo/vector-icons";
import { router } from "expo-router";
import { useMemo } from "react";
import { Image, Pressable, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { openSupportEmail } from "@/constants/contact";
import { useActivity } from "@/context/ActivityContext";
import { useAppSettings } from "@/context/AppSettingsContext";
import BottomTab from "./BottomTab";

const DAYS = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
const LOGO = require("../assets/images/logoapp.png");
const SECTION_SPACING = 32;
const RANDOM_DICTIONARY_SECTIONS = [
  "Pronoms et informations personnelles",
  "Famille",
  "Maison",
  "Cuisine",
  "Temps",
  "Nature",
  "Animaux",
  "Nourriture",
  "Verbes",
  "Expressions",
  "Transport",
  "Travail",
  "Lieux",
  "Social",
  "Adjectifs",
];

export default function HomeScreen() {
  const todayIndex = new Date().getDay();
  const { theme } = useAppSettings();
  const { activeWeekDays, streak } = useActivity();
  const wordOfTheDaySection = useMemo(() => {
    const randomIndex = Math.floor(
      Math.random() * RANDOM_DICTIONARY_SECTIONS.length
    );

    return RANDOM_DICTIONARY_SECTIONS[randomIndex];
  }, []);

  return (
    <SafeAreaView
      style={[styles.container, { backgroundColor: theme.background }]}
    >
      <View style={styles.content}>
        <LogoSection />
        <SectionDivider color={theme.border} />

        <DaysSection
          activeWeekDays={activeWeekDays}
          todayIndex={todayIndex}
          streak={streak}
          textColor={theme.text}
        />
        <SectionDivider color={theme.border} />

        <LessonSection textColor={theme.text} />
        <SectionDivider color={theme.border} />

        <WordOfTheDaySection
          category={wordOfTheDaySection}
          textColor={theme.text}
        />
        <SectionDivider color={theme.border} />

        <HelpSection textColor={theme.text} surfaceColor={theme.surface} />
        <SectionDivider color={theme.border} />
      </View>

      <BottomTab />
    </SafeAreaView>
  );
}

function LogoSection() {
  return (
    <View style={styles.logoSection}>
      <Image source={LOGO} style={styles.logo} resizeMode="contain" />
    </View>
  );
}

function SectionDivider({ color }: { color: string }) {
  return <View style={[styles.divider, { backgroundColor: color }]} />;
}

function DaysSection({
  activeWeekDays,
  todayIndex,
  streak,
  textColor,
}: {
  activeWeekDays: boolean[];
  todayIndex: number;
  streak: number;
  textColor: string;
}) {
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: textColor }]}>
        Les jours
      </Text>

      <View style={styles.daysRow}>
        {DAYS.map((day, index) => {
          const isToday = index === todayIndex;
          const isActive = activeWeekDays[index];

          return (
            <View key={day} style={styles.dayItem}>
              <View
                style={[
                  styles.dayBox,
                  !isActive && styles.inactiveDay,
                  isActive && styles.completedDay,
                  isToday && isActive && styles.activeDay,
                ]}
              >
                {isActive && (
                  <Ionicons
                    name="checkmark-circle-outline"
                    size={18}
                    color="#FFFFFF"
                  />
                )}
              </View>

              <Text
                style={[
                  styles.dayText,
                  { color: textColor },
                  isToday && styles.activeDayText,
                ]}
              >
                {day}
              </Text>
            </View>
          );
        })}
      </View>

      <View style={styles.activity}>
        <Ionicons name="calendar-outline" size={22} color="#B3262E" />
        <Text style={styles.activityNumber}>{streak}</Text>
        <Text style={[styles.activityText, { color: textColor }]}>
          {streak > 1 ? "Jours d'activité" : "Jour d'activité"}
        </Text>
      </View>
    </View>
  );
}

function LessonSection({ textColor }: { textColor: string }) {
  return (
    <View style={styles.section}>
      <View style={styles.cardHeader}>
        <Ionicons name="sparkles-outline" size={16} color="#7B78A8" />
        <Text style={styles.smallText}>Fondation &gt; Leçon 1</Text>
      </View>

      <Text style={[styles.sectionTitle, { color: textColor }]}>
        Nouveaux mots
      </Text>

      <Pressable
        accessibilityRole="button"
        style={styles.primaryButton}
        onPress={() => router.push("/lecons")}
      >
        <Text style={styles.primaryButtonText}>Continuer</Text>
      </Pressable>
    </View>
  );
}

function WordOfTheDaySection({
  category,
  textColor,
}: {
  category: string;
  textColor: string;
}) {
  function openRandomSection() {
    router.push({
      pathname: "/dictionnaire",
      params: { category },
    });
  }

  return (
    <Pressable
      accessibilityRole="button"
      onPress={openRandomSection}
      style={styles.sectionRow}
    >
      <View>
        <Text style={[styles.sectionTitle, { color: textColor }]}>
          Mot du jour
        </Text>
        <Text style={styles.smallText}>#{category}</Text>
      </View>

      <Ionicons name="chevron-forward" size={28} color="#007AFF" />
    </Pressable>
  );
}

function HelpSection({
  textColor,
  surfaceColor,
}: {
  textColor: string;
  surfaceColor: string;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={openSupportEmail}
      style={[styles.helpCard, { backgroundColor: surfaceColor }]}
    >
      <Text style={[styles.sectionTitle, { color: textColor }]}>
        {"Besoin d'aide"}
      </Text>

      <View style={styles.statsRow}>
        <StatItem icon="diamond-outline" label="2052" color={textColor} />
        <StatItem icon="book-outline" label="32 Catégories" color={textColor} />
        <StatItem icon="earth-outline" label="Quiz" color={textColor} />
      </View>

      <View style={styles.practiceButton}>
        <Text style={styles.practiceText}>Besoin de plus de pratique ?</Text>
      </View>
    </Pressable>
  );
}

function StatItem({
  icon,
  label,
  color,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  label: string;
  color: string;
}) {
  return (
    <View style={styles.statItem}>
      <Ionicons name={icon} size={14} color={color} />
      <Text style={[styles.statText, { color }]}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
  },

  content: {
    flex: 1,
    paddingHorizontal: 22,
    paddingBottom: 70,
  },

  logoSection: {
    alignItems: "center",
    paddingTop: 14,
    paddingBottom: 4,
  },

  logo: {
    width: 128,
    height: 88,
  },

  divider: {
    width: "100%",
    height: 1,
    backgroundColor: "#D8D8E0",
    marginVertical: SECTION_SPACING,
  },

  section: {
    width: "100%",
  },

  sectionRow: {
    width: "100%",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  sectionTitle: {
    marginBottom: 10,
    fontSize: 15,
    fontWeight: "800",
    color: "#000000",
  },

  daysRow: {
    width: "100%",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  dayItem: {
    width: 38,
    alignItems: "center",
  },

  dayBox: {
    width: 33,
    height: 33,
    borderRadius: 9,
    backgroundColor: "#202020",
    justifyContent: "center",
    alignItems: "center",
  },

  completedDay: {
    backgroundColor: "#202020",
  },

  inactiveDay: {
    backgroundColor: "#D8D8E0",
  },

  activeDay: {
    backgroundColor: "#0A84FF",
  },

  dayText: {
    marginTop: 5,
    fontSize: 12,
    fontWeight: "700",
    color: "#202020",
  },

  activeDayText: {
    color: "#0A84FF",
  },

  activity: {
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    marginTop: 12,
    gap: 8,
  },

  activityNumber: {
    color: "#007AFF",
    fontSize: 16,
    fontWeight: "800",
  },

  activityText: {
    fontSize: 14,
    color: "#202020",
  },

  cardHeader: {
    flexDirection: "row",
    alignItems: "center",
    gap: 6,
    marginBottom: 4,
  },

  smallText: {
    color: "#7B78A8",
    fontSize: 10,
    fontWeight: "700",
  },

  primaryButton: {
    height: 30,
    backgroundColor: "#34B34A",
    borderRadius: 5,
    justifyContent: "center",
    alignItems: "center",
    marginTop: 2,
  },

  primaryButtonText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },

  statsRow: {
    flexDirection: "row",
    flexWrap: "wrap",
    justifyContent: "center",
    gap: 12,
  },

  statItem: {
    flexDirection: "row",
    alignItems: "center",
    gap: 4,
  },

  statText: {
    fontSize: 11,
    color: "#202020",
  },

  practiceButton: {
    alignSelf: "center",
    backgroundColor: "#9A96C0",
    borderRadius: 5,
    paddingVertical: 7,
    paddingHorizontal: 18,
    marginTop: 12,
  },

  practiceText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },

  helpCard: {
    width: "100%",
    backgroundColor: "#F0F0F5",
    borderRadius: 7,
    paddingVertical: 16,
    paddingHorizontal: 14,
    alignItems: "center",
  },
});
