import { Ionicons } from "@expo/vector-icons";
import { useMemo, useState } from "react";
import { Pressable, ScrollView, StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import BottomTab from "@/app/BottomTab";
import TopBar from "@/app/TopBar";
import { useAppSettings } from "@/context/AppSettingsContext";

type WordItem = {
  fr: string;
  rif: string;
  category: string;
};

type QuizQuestion = {
  id: string;
  prompt: string;
  answer: string;
  category: string;
  options: string[];
};

const QUESTION_COUNT = 10;

const WORDS: WordItem[] = [
  { fr: "moi", rif: "nach", category: "Pronoms" },
  { fr: "toi", rif: "chak", category: "Pronoms" },
  { fr: "il", rif: "netta", category: "Pronoms" },
  { fr: "elle", rif: "nettath", category: "Pronoms" },
  { fr: "nous", rif: "nachin", category: "Pronoms" },
  { fr: "vous", rif: "kaniw", category: "Pronoms" },
  { fr: "pere", rif: "baba", category: "Famille" },
  { fr: "mere", rif: "yemma", category: "Famille" },
  { fr: "frere", rif: "oma", category: "Famille" },
  { fr: "maison", rif: "tadath", category: "Maison" },
  { fr: "chambre", rif: "akaham", category: "Maison" },
  { fr: "porte", rif: "tawath", category: "Maison" },
  { fr: "eau", rif: "aman", category: "Nature" },
  { fr: "soleil", rif: "tfocht", category: "Nature" },
  { fr: "lune", rif: "taziri", category: "Nature" },
  { fr: "pain", rif: "aghrom", category: "Nourriture" },
  { fr: "lait", rif: "aghi", category: "Nourriture" },
  { fr: "viande", rif: "ayssom", category: "Nourriture" },
  { fr: "bonjour", rif: "azul", category: "Expressions" },
  { fr: "merci", rif: "hafek", category: "Expressions" },
  { fr: "oui", rif: "waha", category: "Expressions" },
  { fr: "non", rif: "lah", category: "Expressions" },
  { fr: "voiture", rif: "tonobin", category: "Transport" },
  { fr: "route", rif: "abrid", category: "Transport" },
  { fr: "travail", rif: "rkhadmath", category: "Travail" },
  { fr: "bureau", rif: "birou", category: "Travail" },
  { fr: "grand", rif: "dazira", category: "Adjectifs" },
  { fr: "petit", rif: "da9odadh", category: "Adjectifs" },
  { fr: "facile", rif: "yahwan", category: "Adjectifs" },
  { fr: "difficile", rif: "i9ssah", category: "Adjectifs" },
];

export default function QuizScreen() {
  const { theme } = useAppSettings();
  const [quizSeed, setQuizSeed] = useState(0);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [answers, setAnswers] = useState<(string | null)[]>([]);

  const questions = useMemo(() => buildQuiz(quizSeed), [quizSeed]);
  const currentQuestion = questions[currentIndex];
  const isFinished = answers.length === QUESTION_COUNT;
  const score = answers.reduce((total, answer, index) => {
    return total + (answer === questions[index].answer ? 1 : 0);
  }, 0);
  const successRate = Math.round((score / QUESTION_COUNT) * 100);
  const progress = isFinished
    ? 1
    : (currentIndex + (selectedAnswer ? 1 : 0)) / QUESTION_COUNT;

  function submitAnswer() {
    if (!selectedAnswer) {
      return;
    }

    const nextAnswers = [...answers, selectedAnswer];
    setAnswers(nextAnswers);
    setSelectedAnswer(null);

    if (nextAnswers.length < QUESTION_COUNT) {
      setCurrentIndex((value) => value + 1);
    }
  }

  function restartQuiz() {
    setQuizSeed((value) => value + 1);
    setCurrentIndex(0);
    setSelectedAnswer(null);
    setAnswers([]);
  }

  return (
    <SafeAreaView
      style={[styles.container, { backgroundColor: theme.background }]}
    >
      <TopBar title="Quiz" />

      <ScrollView
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.hero}>
          <View>
            <Text style={styles.heroEyebrow}>Vocabulaire</Text>
            <Text style={styles.heroTitle}>10 mots a tester</Text>
            <Text style={styles.heroSubtitle}>
              Choisis la bonne traduction en rifain.
            </Text>
          </View>

          <View style={styles.heroIcon}>
            <Ionicons name="checkbox-outline" size={30} color="#FFFFFF" />
          </View>
        </View>

        <View style={styles.progressHeader}>
          <Text style={[styles.progressText, { color: theme.text }]}>
            {isFinished ? "Resultat" : `Question ${currentIndex + 1}/10`}
          </Text>
          <Text style={[styles.progressMeta, { color: theme.muted }]}>
            {Math.round(progress * 100)}%
          </Text>
        </View>

        <View style={styles.progressTrack}>
          <View style={[styles.progressFill, { width: `${progress * 100}%` }]} />
        </View>

        {isFinished ? (
          <ResultView
            questions={questions}
            answers={answers}
            score={score}
            successRate={successRate}
            onRestart={restartQuiz}
            theme={theme}
          />
        ) : (
          <QuestionView
            question={currentQuestion}
            selectedAnswer={selectedAnswer}
            onSelect={setSelectedAnswer}
            onSubmit={submitAnswer}
            theme={theme}
          />
        )}
      </ScrollView>

      <BottomTab />
    </SafeAreaView>
  );
}

function QuestionView({
  question,
  selectedAnswer,
  onSelect,
  onSubmit,
  theme,
}: {
  question: QuizQuestion;
  selectedAnswer: string | null;
  onSelect: (answer: string) => void;
  onSubmit: () => void;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
    accent: string;
  };
}) {
  return (
    <View
      style={[
        styles.questionCard,
        { backgroundColor: theme.card, borderColor: theme.border },
      ]}
    >
      <View style={styles.questionHeader}>
        <Text style={styles.categoryText}>{question.category}</Text>
        <Ionicons name="help-circle-outline" size={22} color="#9A96C0" />
      </View>

      <Text style={[styles.questionTitle, { color: theme.text }]}>
        Que veut dire {question.prompt} ?
      </Text>

      <View style={styles.options}>
        {question.options.map((option) => {
          const isSelected = selectedAnswer === option;

          return (
            <Pressable
              key={option}
              accessibilityRole="button"
              onPress={() => onSelect(option)}
              style={[
                styles.optionButton,
                { backgroundColor: theme.card, borderColor: theme.border },
                isSelected && styles.selectedOption,
              ]}
            >
              <Text
                style={[
                  styles.optionText,
                  { color: theme.text },
                  isSelected && styles.selectedOptionText,
                ]}
              >
                {option}
              </Text>
            </Pressable>
          );
        })}
      </View>

      <Pressable
        accessibilityRole="button"
        disabled={!selectedAnswer}
        onPress={onSubmit}
        style={[
          styles.primaryButton,
          !selectedAnswer && styles.disabledButton,
        ]}
      >
        <Text style={styles.primaryButtonText}>Valider</Text>
        <Ionicons name="arrow-forward" size={18} color="#FFFFFF" />
      </Pressable>
    </View>
  );
}

function ResultView({
  questions,
  answers,
  score,
  successRate,
  onRestart,
  theme,
}: {
  questions: QuizQuestion[];
  answers: (string | null)[];
  score: number;
  successRate: number;
  onRestart: () => void;
  theme: {
    card: string;
    text: string;
    muted: string;
    border: string;
    accent: string;
  };
}) {
  const resultColor =
    successRate >= 80 ? "#34B34A" : successRate >= 50 ? "#FF8A00" : "#B3262E";

  return (
    <View>
      <View
        style={[
          styles.resultCard,
          { backgroundColor: theme.card, borderColor: theme.border },
        ]}
      >
        <View style={[styles.scoreCircle, { borderColor: resultColor }]}>
          <Text style={[styles.scoreRate, { color: resultColor }]}>
            {successRate}%
          </Text>
          <Text style={[styles.scoreLabel, { color: theme.muted }]}>
            reussite
          </Text>
        </View>

        <Text style={[styles.resultTitle, { color: theme.text }]}>
          {score}/10 bonnes reponses
        </Text>
        <Text style={[styles.resultText, { color: theme.muted }]}>
          Regarde la correction puis relance un quiz quand tu veux.
        </Text>

        <Pressable
          accessibilityRole="button"
          onPress={onRestart}
          style={styles.primaryButton}
        >
          <Ionicons name="refresh" size={18} color="#FFFFFF" />
          <Text style={styles.primaryButtonText}>Recommencer</Text>
        </Pressable>
      </View>

      <Text style={[styles.correctionTitle, { color: theme.text }]}>
        Correction
      </Text>

      {questions.map((question, index) => {
        const userAnswer = answers[index];
        const isCorrect = userAnswer === question.answer;

        return (
          <View
            key={question.id}
            style={[
              styles.correctionRow,
              { backgroundColor: theme.card, borderColor: theme.border },
            ]}
          >
            <View
              style={[
                styles.correctionIcon,
                { backgroundColor: isCorrect ? "#34B34A" : "#B3262E" },
              ]}
            >
              <Ionicons
                name={isCorrect ? "checkmark" : "close"}
                size={18}
                color="#FFFFFF"
              />
            </View>

            <View style={styles.correctionTextBlock}>
              <Text style={[styles.correctionPrompt, { color: theme.text }]}>
                {index + 1}. {question.prompt}
              </Text>
              <Text style={[styles.correctionAnswer, { color: theme.muted }]}>
                Ta reponse: {userAnswer ?? "-"}
              </Text>
              <Text style={[styles.correctionAnswer, { color: theme.accent }]}>
                Correction: {question.answer}
              </Text>
            </View>
          </View>
        );
      })}
    </View>
  );
}

function buildQuiz(seed: number) {
  void seed;

  const selectedWords = shuffleArray(WORDS).slice(0, QUESTION_COUNT);

  return selectedWords.map((word) => {
    const wrongOptions = shuffleArray(
      WORDS.filter((item) => item.rif !== word.rif).map((item) => item.rif)
    ).slice(0, 3);

    return {
      id: `${word.category}-${word.fr}-${word.rif}`,
      prompt: word.fr,
      answer: word.rif,
      category: word.category,
      options: shuffleArray([word.rif, ...wrongOptions]),
    };
  });
}

function shuffleArray<T>(items: T[]) {
  return [...items].sort(() => Math.random() - 0.5);
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#FFFFFF",
  },

  content: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 86,
  },

  hero: {
    minHeight: 124,
    borderRadius: 8,
    backgroundColor: "#002F63",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 18,
    paddingVertical: 18,
  },

  heroEyebrow: {
    color: "#9A96C0",
    fontSize: 12,
    fontWeight: "900",
    textTransform: "uppercase",
  },

  heroTitle: {
    marginTop: 8,
    color: "#FFFFFF",
    fontSize: 24,
    fontWeight: "900",
  },

  heroSubtitle: {
    marginTop: 7,
    color: "#DCE8F7",
    fontSize: 13,
    fontWeight: "700",
  },

  heroIcon: {
    width: 58,
    height: 58,
    borderRadius: 29,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
  },

  progressHeader: {
    marginTop: 18,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  progressText: {
    color: "#111111",
    fontSize: 15,
    fontWeight: "900",
  },

  progressMeta: {
    color: "#777777",
    fontSize: 12,
    fontWeight: "900",
  },

  progressTrack: {
    height: 7,
    borderRadius: 4,
    backgroundColor: "#E6E6EC",
    marginTop: 9,
    overflow: "hidden",
  },

  progressFill: {
    height: "100%",
    borderRadius: 4,
    backgroundColor: "#0A84FF",
  },

  questionCard: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    marginTop: 18,
    padding: 16,
  },

  questionHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  categoryText: {
    color: "#7B78A8",
    fontSize: 11,
    fontWeight: "900",
    textTransform: "uppercase",
  },

  questionTitle: {
    marginTop: 12,
    color: "#111111",
    fontSize: 22,
    fontWeight: "900",
    lineHeight: 29,
  },

  options: {
    marginTop: 18,
    gap: 10,
  },

  optionButton: {
    minHeight: 50,
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    justifyContent: "center",
    paddingHorizontal: 14,
  },

  selectedOption: {
    borderColor: "#0A84FF",
    backgroundColor: "#0A84FF",
  },

  optionText: {
    color: "#111111",
    fontSize: 15,
    fontWeight: "900",
  },

  selectedOptionText: {
    color: "#FFFFFF",
  },

  primaryButton: {
    minHeight: 44,
    borderRadius: 7,
    backgroundColor: "#34B34A",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 7,
    marginTop: 16,
    paddingHorizontal: 14,
  },

  disabledButton: {
    backgroundColor: "#A7A7A7",
  },

  primaryButtonText: {
    color: "#FFFFFF",
    fontSize: 14,
    fontWeight: "900",
  },

  resultCard: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    marginTop: 18,
    padding: 18,
    alignItems: "center",
  },

  scoreCircle: {
    width: 118,
    height: 118,
    borderRadius: 59,
    borderWidth: 8,
    alignItems: "center",
    justifyContent: "center",
  },

  scoreRate: {
    fontSize: 28,
    fontWeight: "900",
  },

  scoreLabel: {
    color: "#777777",
    fontSize: 11,
    fontWeight: "900",
  },

  resultTitle: {
    marginTop: 14,
    color: "#111111",
    fontSize: 18,
    fontWeight: "900",
  },

  resultText: {
    marginTop: 6,
    color: "#777777",
    fontSize: 13,
    fontWeight: "700",
    textAlign: "center",
    lineHeight: 18,
  },

  correctionTitle: {
    marginTop: 22,
    marginBottom: 10,
    color: "#111111",
    fontSize: 17,
    fontWeight: "900",
  },

  correctionRow: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    flexDirection: "row",
    padding: 12,
    marginBottom: 10,
  },

  correctionIcon: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: "center",
    justifyContent: "center",
    marginRight: 10,
  },

  correctionTextBlock: {
    flex: 1,
  },

  correctionPrompt: {
    color: "#111111",
    fontSize: 14,
    fontWeight: "900",
  },

  correctionAnswer: {
    marginTop: 4,
    color: "#777777",
    fontSize: 12,
    fontWeight: "800",
  },
});
