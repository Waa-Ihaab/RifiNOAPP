import { Stack } from "expo-router";
import { ActivityProvider } from "@/context/ActivityContext";
import { AppSettingsProvider } from "@/context/AppSettingsContext";
import { LanguageProvider } from "@/context/LanguageContext";
import { SavedItemsProvider } from "@/context/SavedItemsContext";

export default function RootLayout() {
  return (
    <AppSettingsProvider>
      <ActivityProvider>
        <LanguageProvider>
          <SavedItemsProvider>
            <Stack screenOptions={{ headerShown: false }} />
          </SavedItemsProvider>
        </LanguageProvider>
      </ActivityProvider>
    </AppSettingsProvider>
  );
}
