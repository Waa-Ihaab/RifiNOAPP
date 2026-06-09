export type RifianLesson = {
  id: string;
  level: string;
  title: string;
  description: string;
  vocabulary: string[];
  phrases: string[];
};

export const finishedLessonIds = new Set<string>();

export const RIFIAN_LESSONS: RifianLesson[] = [
  {
    id: "salutations",
    level: "Fondation",
    title: "Salutations",
    description: "Apprendre les premiers mots pour dire bonjour et repondre.",
    vocabulary: ["Azul = Bonjour", "Mli7 = Ca va", "Bslama = Au revoir"],
    phrases: ["Azul, mli7 ?", "Labas, hamolilah.", "Bslama, ayahbib."],
  },
  {
    id: "famille",
    level: "Fondation",
    title: "Famille",
    description: "Connaitre les mots simples pour parler des proches.",
    vocabulary: ["Baba/Papa = Pere", "Yemma = Mere", "Ouma = Frere"],
    phrases: ["Wanita baba.", "Thanita yemma.", "Yemma t3iz khafi."],
  },
  {
    id: "nombres",
    level: "Base",
    title: "Nombres",
    description: "Compter et reconnaitre les premiers nombres en rifain.",
    vocabulary: ["Wahid = Un", "Tnayen = Deux", "Thrata = Trois"],
    phrases: ["Wahid n djiret.", "Tnayen imouchwan.", "Thrata n 3echi."],
  },
  {
    id: "nature",
    level: "Base",
    title: "Nature",
    description: "Decouvrir des mots utiles autour de la nature.",
    vocabulary: ["Aman = Eau", "Tfocht = Soleil", "Abrid = Chemin"],
    phrases: ["Aman n igzar.", "Tfocht ta9sah.", "Abrid n temsaman."],
  },
];

export function getRifianLessonById(lessonId: string) {
  return RIFIAN_LESSONS.find((lesson) => lesson.id === lessonId);
}
