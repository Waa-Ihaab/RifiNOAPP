import AsyncStorage from "@react-native-async-storage/async-storage";
import { createContext, useCallback, useContext, useEffect, useState } from "react";
import { AppState } from "react-native";

const ACTIVITY_STORAGE_KEY = "rifino.activity.dates";
const MAX_STORED_DAYS = 120;

type ActivityContextType = {
  activeWeekDays: boolean[];
  streak: number;
};

const ActivityContext = createContext<ActivityContextType | null>(null);

export function ActivityProvider({ children }: { children: React.ReactNode }) {
  const [activeWeekDays, setActiveWeekDays] = useState<boolean[]>(
    Array(7).fill(false)
  );
  const [streak, setStreak] = useState(0);

  const recordToday = useCallback(async () => {
    const today = new Date();
    const todayKey = dateToKey(today);
    const storedValue = await AsyncStorage.getItem(ACTIVITY_STORAGE_KEY);
    const storedDates = parseStoredDates(storedValue);
    const updatedDates = Array.from(new Set([...storedDates, todayKey]))
      .filter((dateKey) => isRecentDate(dateKey, today))
      .sort();

    await AsyncStorage.setItem(
      ACTIVITY_STORAGE_KEY,
      JSON.stringify(updatedDates)
    );

    setActiveWeekDays(getActiveWeekDays(updatedDates, today));
    setStreak(getStreak(updatedDates, today));
  }, []);

  useEffect(() => {
    recordToday().catch(() => undefined);

    const subscription = AppState.addEventListener("change", (state) => {
      if (state === "active") {
        recordToday().catch(() => undefined);
      }
    });

    return () => subscription.remove();
  }, [recordToday]);

  return (
    <ActivityContext.Provider value={{ activeWeekDays, streak }}>
      {children}
    </ActivityContext.Provider>
  );
}

export function useActivity() {
  const context = useContext(ActivityContext);

  if (!context) {
    throw new Error("useActivity must be used inside ActivityProvider");
  }

  return context;
}

function parseStoredDates(value: string | null) {
  if (!value) {
    return [];
  }

  try {
    const parsed = JSON.parse(value);

    if (!Array.isArray(parsed)) {
      return [];
    }

    return parsed.filter(
      (date): date is string =>
        typeof date === "string" && /^\d{4}-\d{2}-\d{2}$/.test(date)
    );
  } catch {
    return [];
  }
}

function getActiveWeekDays(dateKeys: string[], today: Date) {
  const weekStart = startOfWeek(today);
  const activeDates = new Set(dateKeys);

  return Array.from({ length: 7 }, (_, index) => {
    const day = addDays(weekStart, index);
    return activeDates.has(dateToKey(day));
  });
}

function getStreak(dateKeys: string[], today: Date) {
  const activeDates = new Set(dateKeys);
  let count = 0;
  let cursor = today;

  while (activeDates.has(dateToKey(cursor))) {
    count += 1;
    cursor = addDays(cursor, -1);
  }

  return count;
}

function isRecentDate(dateKey: string, today: Date) {
  const date = keyToDate(dateKey);
  const oldestAllowedDate = addDays(today, -MAX_STORED_DAYS);

  return date >= startOfDay(oldestAllowedDate) && date <= startOfDay(today);
}

function startOfWeek(date: Date) {
  const start = startOfDay(date);
  start.setDate(start.getDate() - start.getDay());
  return start;
}

function startOfDay(date: Date) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

function addDays(date: Date, days: number) {
  const result = startOfDay(date);
  result.setDate(result.getDate() + days);
  return result;
}

function dateToKey(date: Date) {
  const year = date.getFullYear();
  const month = `${date.getMonth() + 1}`.padStart(2, "0");
  const day = `${date.getDate()}`.padStart(2, "0");

  return `${year}-${month}-${day}`;
}

function keyToDate(dateKey: string) {
  const [year, month, day] = dateKey.split("-").map(Number);
  return new Date(year, month - 1, day);
}
