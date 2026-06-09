import { createContext, useContext, useEffect, useMemo, useState } from "react";
import {
  disableLearningNotifications,
  enableLearningNotifications,
  getLearningNotificationsEnabled,
} from "@/services/learningNotifications";

type AppTheme = {
  background: string;
  surface: string;
  card: string;
  text: string;
  muted: string;
  border: string;
  accent: string;
  tabBackground: string;
  tabInactive: string;
};

type AppSettingsContextType = {
  darkMode: boolean;
  setDarkMode: (value: boolean) => void;
  notifications: boolean;
  setNotifications: (value: boolean) => void;
  soundEffects: boolean;
  setSoundEffects: (value: boolean) => void;
  theme: AppTheme;
};

const AppSettingsContext = createContext<AppSettingsContextType | null>(null);

export function AppSettingsProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications, setNotificationsState] = useState(false);
  const [soundEffects, setSoundEffects] = useState(true);

  useEffect(() => {
    getLearningNotificationsEnabled()
      .then(setNotificationsState)
      .catch(() => undefined);
  }, []);

  const theme = useMemo<AppTheme>(
    () => ({
      background: darkMode ? "#111111" : "#FFFFFF",
      surface: darkMode ? "#1C1C1E" : "#F8F8FA",
      card: darkMode ? "#242426" : "#FFFFFF",
      text: darkMode ? "#FFFFFF" : "#111111",
      muted: darkMode ? "#C8C8D0" : "#777777",
      border: darkMode ? "#3A3A3C" : "#E6E6EC",
      accent: "#0A84FF",
      tabBackground: darkMode ? "#FFFFFF" : "#FFFFFF",
      tabInactive: "#000000",
    }),
    [darkMode]
  );

  async function setNotifications(value: boolean) {
    if (!value) {
      setNotificationsState(false);
      await disableLearningNotifications();
      return;
    }

    const enabled = await enableLearningNotifications();
    setNotificationsState(enabled);
  }

  return (
    <AppSettingsContext.Provider
      value={{
        darkMode,
        setDarkMode,
        notifications,
        setNotifications,
        soundEffects,
        setSoundEffects,
        theme,
      }}
    >
      {children}
    </AppSettingsContext.Provider>
  );
}

export function useAppSettings() {
  const context = useContext(AppSettingsContext);

  if (!context) {
    throw new Error("useAppSettings must be used inside AppSettingsProvider");
  }

  return context;
}
