import { View, Pressable, StyleSheet } from "react-native";
import { router, usePathname } from "expo-router";
import { Feather, Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import { useAppSettings } from "@/context/AppSettingsContext";

export default function BottomTab() {
  const pathname = usePathname();
  const { theme } = useAppSettings();

  const activeColor = theme.accent;
  const inactiveColor = theme.tabInactive;

  return (
    <View
      style={[
        styles.bottomNav,
        { backgroundColor: theme.tabBackground, borderColor: theme.tabInactive },
      ]}
    >
      <Pressable onPress={() => router.push("/home")}>
        <Feather
          name="home"
          size={28}
          color={pathname === "/home" ? activeColor : inactiveColor}
        />
      </Pressable>

      <Pressable onPress={() => router.push("/apprentissage")}>
        <Ionicons
          name="layers-outline"
          size={28}
          color={
            pathname === "/apprentissage"
              ? activeColor
              : inactiveColor
          }
        />
      </Pressable>

      <Pressable onPress={() => router.push("/dictionnaire")}>
        <Ionicons
          name="book-outline"
          size={28}
          color={pathname === "/dictionnaire" ? activeColor : inactiveColor}
        />
      </Pressable>

      <Pressable onPress={() => router.push("/enregistres")}>
        <Feather
          name="bookmark"
          size={28}
          color={pathname === "/enregistres" ? activeColor : inactiveColor}
        />
      </Pressable>

      <Pressable onPress={() => router.push("/settings")}>
        <MaterialCommunityIcons
          name="dots-horizontal-circle-outline"
          size={28}
          color={pathname === "/settings" ? activeColor : inactiveColor}
        />
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  bottomNav: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    height: 55,
    borderTopWidth: 1,
    borderColor: "#000",
    backgroundColor: "#fff",
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center",
  },
});
