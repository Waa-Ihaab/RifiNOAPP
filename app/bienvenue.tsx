import { Image, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { router } from "expo-router";

import AppButton from "@/components/AppButton";
import { useLanguage } from "@/context/LanguageContext";

export default function BienvenueScreen() {
  const { language } = useLanguage();

  const texts = {
    fr: {
      title: "Bienvenue sur Rifino",
      description:
        "La première application pour apprendre le rifain",
      button: "Continuer",
    },

    en: {
      title: "Welcome to Rifino",
      description:
        "The first application to learn Riffian",
      button: "Continue",
    },

    es: {
      title: "Bienvenido a Rifino",
      description:
        "La primera aplicación para aprender rifeño",
      button: "Continuar",
    },
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.main}>
        <Image
          source={require("../assets/images/logoapp.png")}
          style={styles.logo}
          resizeMode="contain"
        />

        <View style={styles.content}>
          <Text style={styles.title}>
            {texts[language].title}
          </Text>

          <Text style={styles.description}>
            {texts[language].description}
          </Text>
        </View>
      </View>

      <AppButton
        title={texts[language].button}
        onPress={() => router.replace("/allonsy")}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
    paddingHorizontal: 24,
    paddingBottom: 80,
  },

  main: {
    flex: 1,
    alignItems: "center",
    paddingTop: 130,
  },

  logo: {
    width: "100%",
    height: 180,
  },

  content: {
    alignItems: "center",
    paddingHorizontal: 16,
    marginTop: 14,
  },

  title: {
    fontSize: 28,
    fontWeight: "700",
    textAlign: "center",
    marginBottom: 2,
  },

  description: {
    fontSize: 18,
    fontWeight: "400",
    color: "#000",
    textAlign: "center",
    lineHeight: 24,
  },
});