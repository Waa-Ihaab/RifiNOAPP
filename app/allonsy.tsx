import { Image, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useState } from "react";

import AppButton from "@/components/AppButton";

import { router } from "expo-router";

const texts = {
  en: { button: "Start" },
  fr: { button: "Commencer" },
};

export default function AllonsyScreen() {
  const [language] = useState("fr");

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
            Bienvenue sur votre{"\n"}
            première leçon !
          </Text>

          <Text style={styles.description}>
            Commençons à apprendre
          </Text>
        </View>
      </View>

              <AppButton title="Allons-y" onPress={() => router.replace("/home")} />
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

  main: {
    alignItems: "center",
    marginTop: 130,
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