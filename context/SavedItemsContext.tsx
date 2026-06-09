import AsyncStorage from "@react-native-async-storage/async-storage";
import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";

export type SavedAudio = {
  id: string;
  title: string;
  translation: string;
  section: string;
};

export type SavedWord = {
  id: string;
  fr: string;
  rif: string;
  category: string;
};

export type SavedLesson = {
  id: string;
  title: string;
  level: string;
  description: string;
};

type SavedItemsState = {
  audios: SavedAudio[];
  words: SavedWord[];
  lessons: SavedLesson[];
};

type SavedItemsContextType = SavedItemsState & {
  toggleAudio: (audio: SavedAudio) => void;
  toggleWord: (word: SavedWord) => void;
  toggleLesson: (lesson: SavedLesson) => void;
  removeAudio: (audioId: string) => void;
  removeWord: (wordId: string) => void;
  removeLesson: (lessonId: string) => void;
  isAudioSaved: (audioId: string) => boolean;
  isWordSaved: (wordId: string) => boolean;
  isLessonSaved: (lessonId: string) => boolean;
};

const STORAGE_KEY = "rifino.savedItems";

const DEFAULT_STATE: SavedItemsState = {
  audios: [],
  words: [],
  lessons: [],
};

const SavedItemsContext = createContext<SavedItemsContextType | null>(null);

export function SavedItemsProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  const [items, setItems] = useState<SavedItemsState>(DEFAULT_STATE);
  const [hasLoaded, setHasLoaded] = useState(false);

  useEffect(() => {
    AsyncStorage.getItem(STORAGE_KEY)
      .then((storedValue) => {
        if (!storedValue) {
          return;
        }

        const parsedValue = JSON.parse(storedValue) as Partial<SavedItemsState>;

        setItems({
          audios: parsedValue.audios ?? [],
          words: parsedValue.words ?? [],
          lessons: parsedValue.lessons ?? [],
        });
      })
      .catch(() => undefined)
      .finally(() => setHasLoaded(true));
  }, []);

  useEffect(() => {
    if (!hasLoaded) {
      return;
    }

    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(items)).catch(
      () => undefined
    );
  }, [hasLoaded, items]);

  const toggleAudio = useCallback((audio: SavedAudio) => {
    setItems((currentItems) => {
      const exists = currentItems.audios.some((item) => item.id === audio.id);

      return {
        ...currentItems,
        audios: exists
          ? currentItems.audios.filter((item) => item.id !== audio.id)
          : [audio, ...currentItems.audios],
      };
    });
  }, []);

  const toggleWord = useCallback((word: SavedWord) => {
    setItems((currentItems) => {
      const exists = currentItems.words.some((item) => item.id === word.id);

      return {
        ...currentItems,
        words: exists
          ? currentItems.words.filter((item) => item.id !== word.id)
          : [word, ...currentItems.words],
      };
    });
  }, []);

  const toggleLesson = useCallback((lesson: SavedLesson) => {
    setItems((currentItems) => {
      const exists = currentItems.lessons.some((item) => item.id === lesson.id);

      return {
        ...currentItems,
        lessons: exists
          ? currentItems.lessons.filter((item) => item.id !== lesson.id)
          : [lesson, ...currentItems.lessons],
      };
    });
  }, []);

  const removeAudio = useCallback((audioId: string) => {
    setItems((currentItems) => ({
      ...currentItems,
      audios: currentItems.audios.filter((item) => item.id !== audioId),
    }));
  }, []);

  const removeWord = useCallback((wordId: string) => {
    setItems((currentItems) => ({
      ...currentItems,
      words: currentItems.words.filter((item) => item.id !== wordId),
    }));
  }, []);

  const removeLesson = useCallback((lessonId: string) => {
    setItems((currentItems) => ({
      ...currentItems,
      lessons: currentItems.lessons.filter((item) => item.id !== lessonId),
    }));
  }, []);

  const isAudioSaved = useCallback(
    (audioId: string) => items.audios.some((item) => item.id === audioId),
    [items.audios]
  );

  const isWordSaved = useCallback(
    (wordId: string) => items.words.some((item) => item.id === wordId),
    [items.words]
  );

  const isLessonSaved = useCallback(
    (lessonId: string) => items.lessons.some((item) => item.id === lessonId),
    [items.lessons]
  );

  const value = useMemo<SavedItemsContextType>(
    () => ({
      ...items,
      toggleAudio,
      toggleWord,
      toggleLesson,
      removeAudio,
      removeWord,
      removeLesson,
      isAudioSaved,
      isWordSaved,
      isLessonSaved,
    }),
    [
      items,
      toggleAudio,
      toggleWord,
      toggleLesson,
      removeAudio,
      removeWord,
      removeLesson,
      isAudioSaved,
      isWordSaved,
      isLessonSaved,
    ]
  );

  return (
    <SavedItemsContext.Provider value={value}>
      {children}
    </SavedItemsContext.Provider>
  );
}

export function useSavedItems() {
  const context = useContext(SavedItemsContext);

  if (!context) {
    throw new Error("useSavedItems must be used inside SavedItemsProvider");
  }

  return context;
}
