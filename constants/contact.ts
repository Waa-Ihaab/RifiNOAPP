import { Linking } from "react-native";

export const SUPPORT_EMAILS = [
  "contcat.support@gmail.com",
  "contact.kariihab@gmail.com",
];

export function openSupportEmail() {
  const recipients = SUPPORT_EMAILS.join(",");
  const subject = encodeURIComponent("Support Rifino");
  const body = encodeURIComponent("Bonjour,\n\n");

  Linking.openURL(`mailto:${recipients}?subject=${subject}&body=${body}`).catch(
    () => undefined
  );
}
