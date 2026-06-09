import AsyncStorage from "@react-native-async-storage/async-storage";
import * as Notifications from "expo-notifications";
import { Platform } from "react-native";

const CHANNEL_ID = "learning-reminders";
const LAST_LESSON_KEY = "rifino.lastLessonReminder";
const NOTIFICATIONS_ENABLED_KEY = "rifino.learningNotificationsEnabled";
const REMINDER_IDS = ["rifino-reminder-morning", "rifino-reminder-evening"];

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowBanner: true,
    shouldShowList: true,
    shouldPlaySound: false,
    shouldSetBadge: false,
  }),
});

export async function enableLearningNotifications() {
  await ensureNotificationChannel();

  const currentPermissions = await Notifications.getPermissionsAsync();
  const finalPermissions = currentPermissions.granted
    ? currentPermissions
    : await Notifications.requestPermissionsAsync();

  if (!finalPermissions.granted) {
    await AsyncStorage.setItem(NOTIFICATIONS_ENABLED_KEY, "false");
    await cancelLearningNotifications();
    return false;
  }

  await AsyncStorage.setItem(NOTIFICATIONS_ENABLED_KEY, "true");
  await scheduleLearningNotifications();
  return true;
}

export async function disableLearningNotifications() {
  await AsyncStorage.setItem(NOTIFICATIONS_ENABLED_KEY, "false");
  await cancelLearningNotifications();
}

export async function getLearningNotificationsEnabled() {
  const isEnabled = await AsyncStorage.getItem(NOTIFICATIONS_ENABLED_KEY);
  return isEnabled === "true";
}

export async function rememberLessonForNotifications(lessonTitle: string) {
  await AsyncStorage.setItem(LAST_LESSON_KEY, lessonTitle);

  const isEnabled = await AsyncStorage.getItem(NOTIFICATIONS_ENABLED_KEY);
  if (isEnabled !== "true") {
    return;
  }

  const permissions = await Notifications.getPermissionsAsync();
  if (permissions.granted) {
    await scheduleLearningNotifications();
  }
}

async function ensureNotificationChannel() {
  if (Platform.OS !== "android") {
    return;
  }

  await Notifications.setNotificationChannelAsync(CHANNEL_ID, {
    name: "Rappels apprentissage",
    importance: Notifications.AndroidImportance.DEFAULT,
    vibrationPattern: [0, 220, 160, 220],
    lightColor: "#0A84FF",
  });
}

async function scheduleLearningNotifications() {
  await cancelLearningNotifications();

  const lessonTitle = await AsyncStorage.getItem(LAST_LESSON_KEY);
  const messages = buildReminderMessages(lessonTitle);

  await Notifications.scheduleNotificationAsync({
    identifier: REMINDER_IDS[0],
    content: {
      title: messages.morning.title,
      body: messages.morning.body,
      data: { screen: "/lecons" },
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.DAILY,
      hour: 10,
      minute: 0,
      channelId: CHANNEL_ID,
    },
  });

  await Notifications.scheduleNotificationAsync({
    identifier: REMINDER_IDS[1],
    content: {
      title: messages.evening.title,
      body: messages.evening.body,
      data: { screen: "/lecons" },
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.DAILY,
      hour: 19,
      minute: 30,
      channelId: CHANNEL_ID,
    },
  });
}

async function cancelLearningNotifications() {
  await Promise.all(
    REMINDER_IDS.map((identifier) =>
      Notifications.cancelScheduledNotificationAsync(identifier).catch(
        () => undefined
      )
    )
  );
}

function buildReminderMessages(lessonTitle: string | null) {
  if (lessonTitle) {
    return {
      morning: {
        title: "Azul",
        body: `On continue la lecon ${lessonTitle} ? 5 minutes suffisent.`,
      },
      evening: {
        title: "Petit rappel Rifino",
        body: `Reprendre ${lessonTitle} maintenant peut vraiment aider.`,
      },
    };
  }

  return {
    morning: {
      title: "Azul",
      body: "On apprend quelques mots aujourd'hui ?",
    },
    evening: {
      title: "Rifino t'attend",
      body: "Un mini quiz ou une lecon rapide pour garder le rythme.",
    },
  };
}
