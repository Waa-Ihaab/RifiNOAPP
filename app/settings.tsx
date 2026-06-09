import { Ionicons } from "@expo/vector-icons";
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Switch,
  Text,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import BottomTab from "@/app/BottomTab";
import TopBar from "@/app/TopBar";
import { useAppSettings } from "@/context/AppSettingsContext";
import { openSupportEmail, SUPPORT_EMAILS } from "@/constants/contact";

export default function SettingsScreen() {
  const {
    darkMode,
    setDarkMode,
    notifications,
    setNotifications,
    soundEffects,
    setSoundEffects,
    theme,
  } = useAppSettings();

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
      <TopBar title="Réglages" />

      <ScrollView
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <View style={[styles.hero, { backgroundColor: theme.surface }]}>
          <View>
            <Text style={[styles.heroTitle, { color: theme.text }]}>
              Paramètres
            </Text>
            <Text style={[styles.heroSubtitle, { color: theme.muted }]}>
              Personnalise ton expérience Rifino.
            </Text>
          </View>

          <View style={styles.heroIcon}>
            <Ionicons name="settings-outline" size={30} color="#FFFFFF" />
          </View>
        </View>

        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.text }]}>
            Préférences
          </Text>

          <SettingSwitch
            icon="moon-outline"
            title="Mode sombre"
            subtitle={darkMode ? "Activé" : "Désactivé"}
            value={darkMode}
            onValueChange={setDarkMode}
            theme={theme}
          />

          <SettingSwitch
            icon="notifications-outline"
            title="Notifications"
            subtitle={notifications ? "Rappels autorisés" : "Rappels désactivés"}
            value={notifications}
            onValueChange={setNotifications}
            theme={theme}
          />

          <SettingSwitch
            icon="volume-high-outline"
            title="Sons"
            subtitle={soundEffects ? "Effets audio activés" : "Effets audio coupés"}
            value={soundEffects}
            onValueChange={setSoundEffects}
            theme={theme}
          />
        </View>

        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.text }]}>
            Support
          </Text>

          <Pressable
            accessibilityRole="button"
            onPress={openSupportEmail}
            style={[
              styles.contactCard,
              { backgroundColor: theme.card, borderColor: theme.border },
            ]}
          >
            <View style={styles.contactIcon}>
              <Ionicons name="mail-outline" size={22} color="#FFFFFF" />
            </View>

            <View style={styles.contactText}>
              <Text style={[styles.settingTitle, { color: theme.text }]}>
                Contact
              </Text>
              <Text style={[styles.settingSubtitle, { color: theme.muted }]}>
                {SUPPORT_EMAILS.join(" / ")}
              </Text>
            </View>

            <Ionicons name="chevron-forward" size={22} color={theme.muted} />
          </Pressable>
        </View>
      </ScrollView>

      <BottomTab />
    </SafeAreaView>
  );
}

function SettingSwitch({
  icon,
  title,
  subtitle,
  value,
  onValueChange,
  theme,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  title: string;
  subtitle: string;
  value: boolean;
  onValueChange: (value: boolean) => void;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
    accent: string;
  };
}) {
  return (
    <View
      style={[
        styles.settingCard,
        { backgroundColor: theme.card, borderColor: theme.border },
      ]}
    >
      <View style={styles.settingIcon}>
        <Ionicons name={icon} size={22} color="#FFFFFF" />
      </View>

      <View style={styles.settingText}>
        <Text style={[styles.settingTitle, { color: theme.text }]}>{title}</Text>
        <Text style={[styles.settingSubtitle, { color: theme.muted }]}>
          {subtitle}
        </Text>
      </View>

      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: "#D8D8E0", true: "#8BC7FF" }}
        thumbColor={value ? theme.accent : "#FFFFFF"}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  content: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 86,
  },

  hero: {
    minHeight: 108,
    borderRadius: 8,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 18,
    paddingVertical: 16,
  },

  heroTitle: {
    fontSize: 24,
    fontWeight: "900",
  },

  heroSubtitle: {
    marginTop: 6,
    fontSize: 13,
    fontWeight: "700",
  },

  heroIcon: {
    width: 54,
    height: 54,
    borderRadius: 27,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
  },

  section: {
    marginTop: 22,
  },

  sectionTitle: {
    marginBottom: 10,
    fontSize: 16,
    fontWeight: "900",
  },

  settingCard: {
    minHeight: 72,
    borderWidth: 1,
    borderRadius: 8,
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    marginBottom: 10,
  },

  settingIcon: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#002F63",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 12,
  },

  settingText: {
    flex: 1,
    paddingRight: 10,
  },

  settingTitle: {
    fontSize: 15,
    fontWeight: "900",
  },

  settingSubtitle: {
    marginTop: 3,
    fontSize: 12,
    fontWeight: "700",
  },

  contactCard: {
    minHeight: 72,
    borderWidth: 1,
    borderRadius: 8,
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
  },

  contactIcon: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#34B34A",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 12,
  },

  contactText: {
    flex: 1,
  },
});
