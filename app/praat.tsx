import { useState } from "react";
import { Image, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { router } from "expo-router";

import AppButton from "@/components/AppButton";
import { useLanguage } from "@/context/LanguageContext";

export default function PraatScreen() {
  const [selectedLanguage, setSelectedLanguage] =
    useState("Français");

  const { setLanguage } = useLanguage();

  const languages = ["Français", "English", "Espanol"];

  return (
    <SafeAreaView style={styles.container}>
      <View>
        <Image
          source={require("../assets/images/logoapp.png")}
          style={styles.logo}
          resizeMode="contain"
        />

        <View style={styles.content}>
          <Text style={styles.title}>Je parle...</Text>

          {languages.map((language) => (
            <View key={language} style={styles.languageButton}>
              <AppButton
                title={language}
                variant={
                  selectedLanguage === language
                    ? "primary"
                    : "secondary"
                }
                onPress={() => {
                  setSelectedLanguage(language);

                  if (language === "Français")
                    setLanguage("fr");

                  if (language === "English")
                    setLanguage("en");

                  if (language === "Espanol")
                    setLanguage("es");
                }}
              />
            </View>
          ))}
        </View>
      </View>

      <AppButton
        title="Continuer"
        onPress={() => router.replace("/allonsy")}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#F4F4F4",
    paddingHorizontal: 24,
    paddingBottom: 80,
    justifyContent: "space-between",
  },

  logo: {
    width: "70%",
    height: 120,
    alignSelf: "center",
    marginTop: 60,
  },

  content: {
    marginTop: 90,
  },

  title: {
    fontSize: 30,
    fontWeight: "700",
    marginBottom: 20,
  },

  languageButton: {
    marginBottom: 12,
  },
});