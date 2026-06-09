import { Pressable, StyleSheet, Text, View } from "react-native";
import { Ionicons } from "@expo/vector-icons";
import { router } from "expo-router";
import { useAppSettings } from "@/context/AppSettingsContext";

export default function TopBar({ title }: { title: string }) {
  const { theme } = useAppSettings();

  return (
    <View
      style={[
        styles.topBar,
        { backgroundColor: theme.background, borderBottomColor: theme.border },
      ]}
    >
      <Pressable onPress={() => router.back()} style={styles.backButton}>
        <Ionicons name="chevron-back" size={28} color={theme.text} />
      </Pressable>

      <Text style={[styles.title, { color: theme.text }]}>{title}</Text>

      <View style={styles.empty} />
    </View>
  );
}

const styles = StyleSheet.create({
  topBar: {
    height: 55,
    borderBottomWidth: 1,
    borderBottomColor: "#DDD",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 12,
    backgroundColor: "#fff",
  },

  backButton: {
    width: 40,
    height: 40,
    justifyContent: "center",
  },

  title: {
    fontSize: 18,
    fontWeight: "800",
    color: "#000",
  },

  empty: {
    width: 40,
  },
});
