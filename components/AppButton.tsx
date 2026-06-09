import { Pressable, StyleSheet, Text } from "react-native";

type AppButtonProps = {
  title: string;
  onPress?: () => void;
  variant?: "primary" | "secondary";
};

export default function AppButton({
  title,
  onPress,
  variant = "primary",
}: AppButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      style={[
        styles.button,
        variant === "primary" ? styles.primary : styles.secondary,
      ]}
    >
      <Text
        style={[
          styles.text,
          variant === "primary" ? styles.primaryText : styles.secondaryText,
        ]}
      >
        {title}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    height: 42,
    borderRadius: 9,
    justifyContent: "center",
    alignItems: "center",
    width: "100%",
  },

  primary: {
    backgroundColor: "#007AFF",
  },

  secondary: {
    backgroundColor: "#F0F0F5",
  },

  text: {
    fontSize: 16,
    fontWeight: "700",
  },

  primaryText: {
    color: "#FFFFFF",
  },

  secondaryText: {
    color: "#007AFF",
  },
});