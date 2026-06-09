import { useEffect } from "react";
import { Image, StyleSheet } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { router } from "expo-router";

export default function LoadScreen() {
  useEffect(() => {
    const timer = setTimeout(() => {
      router.replace("/bienvenue");
    }, 2000);

    return () => clearTimeout(timer);
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <Image
        source={require("../assets/images/logoapp.png")}
        style={styles.logo}
        resizeMode="contain"
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#F4F4F4",
    justifyContent: "center",
    alignItems: "center",
  },

  logo: {
    width: "100%",
    height: 220,
  },
});