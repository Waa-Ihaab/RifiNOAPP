import React from "react";
import {
  Image,
  Pressable,
  StyleSheet,
  Text,
  View,
} from "react-native";

import { Ionicons } from "@expo/vector-icons";
import { router, usePathname } from "expo-router";

import BottomTab from "@/app/BottomTab";
import { openSupportEmail } from "@/constants/contact";
import { useAppSettings } from "@/context/AppSettingsContext";

export default function ApprentissageScreen() {
  const pathname = usePathname();
  const { theme } = useAppSettings();

  return (
    <View style={[styles.container, { backgroundColor: theme.background }]}>
      <Image
        source={require("../assets/images/logoapp.png")}
        style={styles.logo}
        resizeMode="contain"
      />

      <Text style={[styles.title, { color: theme.text }]}>Apprentissage</Text>

      <MenuCard
        title="Audio & Prononciation"
        subtitle="Écoute et répète les sons rifains"
        icon="musical-notes-outline"
        active={pathname === "/audio"}
        onPress={() => router.push("/audio")}
      />

      <MenuCard
        title="Dictionnaire"
        subtitle="Tarifit ↔ Français"
        icon="book-outline"
        active={pathname === "/dictionnaire"}
        onPress={() => router.push("/dictionnaire")}
      />

      <MenuCard
        title="Quiz"
        subtitle="Teste tes connaissances"
        icon="checkbox-outline"
        active={pathname === "/quiz"}
        onPress={() => router.push("/quiz")}
      />

      <MenuCard
        title="Leçons"
        subtitle="Grammaire · Conjugaison · Dialogues"
        icon="newspaper-outline"
        active={pathname === "/lecons"}
        onPress={() => router.push("/lecons")}
      />

      <Pressable
        accessibilityRole="button"
        onPress={openSupportEmail}
        style={[styles.infoBox, { backgroundColor: theme.surface }]}
      >
        <Text style={[styles.infoTitle, { color: theme.text }]}>
          {"Besoin d'aide"}
        </Text>

        <View style={styles.stats}>
          <View style={styles.statItem}>
            <Ionicons name="diamond-outline" size={14} color={theme.text} />
            <Text style={[styles.stat, { color: theme.text }]}>2052</Text>
          </View>

          <View style={styles.statItem}>
            <Ionicons name="book-outline" size={14} color={theme.text} />
            <Text style={[styles.stat, { color: theme.text }]}>
              32 Catégories
            </Text>
          </View>

          <View style={styles.statItem}>
            <Ionicons name="earth-outline" size={14} color={theme.text} />
            <Text style={[styles.stat, { color: theme.text }]}>Quiz</Text>
          </View>
        </View>

        <View style={styles.button}>
          <Text style={styles.buttonText}>Besoin de plus de pratique ?</Text>
        </View>
      </Pressable>

      <BottomTab />
    </View>
  );
}

function MenuCard({
  title,
  subtitle,
  icon,
  onPress,
  active = false,
}: {
  title: string;
  subtitle: string;
  icon: keyof typeof Ionicons.glyphMap;
  onPress: () => void;
  active?: boolean;
}) {
  return (
    <Pressable
      style={[styles.card, active ? styles.activeCard : styles.inactiveCard]}
      onPress={onPress}
    >
      <View style={active ? styles.circle : styles.circleGray}>
        <Ionicons name={icon} size={28} color="#111" />
      </View>

      <View>
        <Text style={styles.cardTitle}>{title}</Text>
        <Text style={styles.cardSubtitle}>{subtitle}</Text>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
    paddingHorizontal: 16,
    paddingTop: 65,
  },

  logo: {
    width: 185,
    height: 105,
    alignSelf: "center",
    marginBottom: 5,
  },

  title: {
    fontSize: 24,
    fontWeight: "800",
    textAlign: "center",
    color: "#000",
    marginBottom: 55,
  },

  card: {
    height: 58,
    borderRadius: 7,
    marginBottom: 19,
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
  },

  activeCard: {
    backgroundColor: "#002F63",
  },

  inactiveCard: {
    backgroundColor: "#A7A7A7",
  },

  circle: {
    width: 48,
    height: 48,
    borderRadius: 24,
    borderWidth: 3,
    borderColor: "#00A9FF",
    backgroundColor: "#D9D9D9",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 13,
  },

  circleGray: {
    width: 48,
    height: 48,
    borderRadius: 24,
    borderWidth: 3,
    borderColor: "#E5E5E5",
    backgroundColor: "#CFCFCF",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 13,
  },

  cardTitle: {
    color: "#FFFFFF",
    fontSize: 15,
    fontWeight: "800",
  },

  cardSubtitle: {
    color: "#FFFFFF",
    fontSize: 9,
    fontWeight: "700",
    marginTop: 2,
  },

  infoBox: {
    width: "100%",
    marginTop: 0,
    backgroundColor: "#F0F0F5",
    borderRadius: 7,
    paddingVertical: 16,
    paddingHorizontal: 14,
    alignItems: "center",
  },

  infoTitle: {
    marginBottom: 10,
    fontSize: 15,
    fontWeight: "800",
    color: "#000000",
  },

  stats: {
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

  stat: {
    fontSize: 11,
    fontWeight: "700",
    color: "#202020",
  },

  button: {
    alignSelf: "center",
    backgroundColor: "#9A96C0",
    borderRadius: 5,
    paddingVertical: 7,
    paddingHorizontal: 18,
    marginTop: 12,
    alignItems: "center",
    justifyContent: "center",
  },

  buttonText: {
    color: "#FFFFFF",
    fontWeight: "700",
  },
});
