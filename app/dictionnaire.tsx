import { Ionicons } from "@expo/vector-icons";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useMemo, useState } from "react";
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

import BottomTab from "@/app/BottomTab";
import TopBar from "@/app/TopBar";
import { useAppSettings } from "@/context/AppSettingsContext";
import { useSavedItems } from "@/context/SavedItemsContext";

type DictionaryEntry = {
  fr: string;
  rif: string;
};

type DictionaryCategory = {
  title: string;
  icon: keyof typeof Ionicons.glyphMap;
  color: string;
  entries: DictionaryEntry[];
};

const CATEGORIES: DictionaryCategory[] = [
  {
    title: "Pronoms et informations personnelles",
    icon: "person-circle-outline",
    color: "#0A84FF",
    entries: [
      { fr: "moi", rif: "nach" },
      { fr: "toi", rif: "chak" },
      { fr: "il", rif: "netta" },
      { fr: "elle", rif: "nettath" },
      { fr: "nous", rif: "nachin" },
      { fr: "vous", rif: "kaniw" },
      { fr: "eux", rif: "nithni" },
      { fr: "nom", rif: "takniya" },
      { fr: "prénom", rif: "issam" },
      { fr: "âge", rif: "r3omwa" },
      { fr: "pays", rif: "doula" },
      { fr: "ville", rif: "abilaj" },
    ],
  },
  {
    title: "Famille",
    icon: "people-outline",
    color: "#34B34A",
    entries: [
      { fr: "père", rif: "baba" },
      { fr: "mère", rif: "yemma" },
      { fr: "frère", rif: "oma" },
      { fr: "sœur", rif: "otchma" },
      { fr: "enfant", rif: "ahanja" },
      { fr: "bébé", rif: "assimi" },
      { fr: "grand-père", rif: "jeddi" },
      { fr: "grand-mère", rif: "henna" },
      { fr: "tante", rif: "khatchi" },
      { fr: "oncle", rif: "khari" },
      { fr: "cousin", rif: "miss an khari" },
      { fr: "cousine", rif: "idjiss an khatchi" },
      { fr: "mari", rif: "ayaz" },
      { fr: "femme", rif: "tamghat" },
      { fr: "ami", rif: "amadokar" },
      { fr: "amie", rif: "tamadokct" },
      { fr: "voisin", rif: "aja" },
      { fr: "voisine", rif: "tajath" },
    ],
  },
  {
    title: "Maison",
    icon: "home-outline",
    color: "#B3262E",
    entries: [
      { fr: "maison", rif: "tadath" },
      { fr: "appartement", rif: "apartman" },
      { fr: "chambre", rif: "akaham" },
      { fr: "salon", rif: "sala" },
      { fr: "cuisine", rif: "kuzina" },
      { fr: "salle de bain", rif: "dotcha" },
      { fr: "lit", rif: "9ama" },
      { fr: "table", rif: "tabra" },
      { fr: "chaise", rif: "rkwassi" },
      { fr: "armoire", rif: "mariyo" },
      { fr: "miroir", rif: "tisith" },
      { fr: "porte", rif: "tawath" },
      { fr: "fenêtre", rif: "rkazi" },
      { fr: "clé", rif: "raftah" },
      { fr: "mur", rif: "rhid" },
      { fr: "sol", rif: "tamwath" },
      { fr: "plafond", rif: "taza9a" },
    ],
  },
  {
    title: "Cuisine",
    icon: "restaurant-outline",
    color: "#FF8A00",
    entries: [
      { fr: "cuillère", rif: "taghanjacht" },
      { fr: "fourchette", rif: "fachita" },
      { fr: "couteau", rif: "rmoss" },
      { fr: "assiette", rif: "tabssi" },
      { fr: "verre", rif: "rkass" },
      { fr: "tasse", rif: "tagharaft" },
      { fr: "frigo", rif: "nibira" },
      { fr: "four", rif: "fwana" },
      { fr: "bol", rif: "aghanja" },
    ],
  },
  {
    title: "Éléments",
    icon: "flash-outline",
    color: "#7B78A8",
    entries: [
      { fr: "lumière", rif: "tfawkth" },
      { fr: "eau", rif: "aman" },
      { fr: "feu", rif: "timassi" },
      { fr: "électricité", rif: "trissinti" },
    ],
  },
  {
    title: "Temps",
    icon: "time-outline",
    color: "#0E8C7F",
    entries: [
      { fr: "aujourd'hui", rif: "nhara" },
      { fr: "demain", rif: "tiwocha" },
      { fr: "hier", rif: "idanad" },
      { fr: "matin", rif: "sbah" },
      { fr: "après-midi", rif: "o3achi" },
      { fr: "soir", rif: "tamadith" },
      { fr: "nuit", rif: "djirath" },
      { fr: "heure", rif: "sa3ath" },
      { fr: "minute", rif: "tminot" },
      { fr: "seconde", rif: "sikond" },
      { fr: "jour", rif: "nha" },
      { fr: "semaine", rif: "simana" },
      { fr: "mois", rif: "cha" },
      { fr: "année", rif: "3aam" },
    ],
  },
  {
    title: "Nature",
    icon: "leaf-outline",
    color: "#2F8A3E",
    entries: [
      { fr: "soleil", rif: "tfocht" },
      { fr: "lune", rif: "taziri" },
      { fr: "étoile", rif: "ithri / ithran" },
      { fr: "nuage", rif: "assino" },
      { fr: "pluie", rif: "anza" },
      { fr: "neige", rif: "adfar" },
      { fr: "vent", rif: "assamidh" },
      { fr: "mer", rif: "rabha" },
      { fr: "montagne", rif: "adhra" },
      { fr: "désert", rif: "rakhra" },
      { fr: "arbre", rif: "ssja" },
      { fr: "fleur", rif: "tanowachth" },
      { fr: "herbe", rif: "arbi3" },
      { fr: "pierre", rif: "izra" },
      { fr: "lac", rif: "tassadja" },
      { fr: "rivière", rif: "ighza" },
    ],
  },
  {
    title: "Animaux",
    icon: "paw-outline",
    color: "#6B5A2E",
    entries: [
      { fr: "poisson", rif: "assram" },
      { fr: "chat", rif: "moch" },
      { fr: "chien", rif: "a9zin" },
      { fr: "oiseau", rif: "ajdid" },
      { fr: "cheval", rif: "assadon" },
      { fr: "vache", rif: "tafounasst" },
      { fr: "mouton", rif: "ahori" },
      { fr: "serpent", rif: "figha" },
    ],
  },
  {
    title: "Nourriture",
    icon: "nutrition-outline",
    color: "#D14A2F",
    entries: [
      { fr: "pain", rif: "aghrom" },
      { fr: "lait", rif: "aghi" },
      { fr: "fromage", rif: "fomaj" },
      { fr: "viande", rif: "ayssom" },
      { fr: "poulet", rif: "yazidh" },
      { fr: "œuf", rif: "tamadjach" },
      { fr: "pomme", rif: "tafah" },
      { fr: "banane", rif: "lbanan" },
      { fr: "orange", rif: "lachin" },
      { fr: "tomate", rif: "tomahtich" },
      { fr: "thé", rif: "atay" },
      { fr: "café", rif: "9ahwa" },
    ],
  },
  {
    title: "Verbes",
    icon: "chatbubble-ellipses-outline",
    color: "#005FB8",
    entries: [
      { fr: "être", rif: "a9ayi" },
      { fr: "avoir", rif: "ghari" },
      { fr: "faire", rif: "tagakh" },
      { fr: "aller", rif: "tahakh" },
      { fr: "venir", rif: "tassaghd" },
      { fr: "manger", rif: "tatakh" },
      { fr: "boire", rif: "sassakh" },
      { fr: "dormir", rif: "tatsakh" },
      { fr: "parler", rif: "sawarakh" },
      { fr: "voir", rif: "ghazakh" },
      { fr: "aimer", rif: "thibikh" },
    ],
  },
  {
    title: "Expressions",
    icon: "happy-outline",
    color: "#9A4D9E",
    entries: [
      { fr: "bonjour", rif: "salem aleykoum" },
      { fr: "merci", rif: "hafek" },
      { fr: "oui", rif: "waha" },
      { fr: "non", rif: "lah" },
      { fr: "d'accord", rif: "wakha" },
    ],
  },
  {
    title: "Transport",
    icon: "car-outline",
    color: "#455A64",
    entries: [
      { fr: "voiture", rif: "tonobin" },
      { fr: "bus", rif: "lbuss" },
      { fr: "train", rif: "machina" },
      { fr: "avion", rif: "tiyara" },
      { fr: "vélo", rif: "bassklit" },
      { fr: "route", rif: "abrid" },
      { fr: "rue", rif: "chari3" },
    ],
  },
  {
    title: "Éducation",
    icon: "school-outline",
    color: "#6D6A00",
    entries: [
      { fr: "école", rif: "madrassa" },
      { fr: "université", rif: "université" },
      { fr: "cahier", rif: "tafta" },
      { fr: "livre", rif: "lkitab" },
      { fr: "stylo", rif: "stilo" },
      { fr: "lire", rif: "9akh" },
      { fr: "écrire", rif: "tarikh" },
      { fr: "professeur", rif: "usstad" },
      { fr: "élève", rif: "amahdha" },
    ],
  },
  {
    title: "Travail",
    icon: "briefcase-outline",
    color: "#8E5A25",
    entries: [
      { fr: "travail", rif: "rkhadmath" },
      { fr: "bureau", rif: "birou" },
      { fr: "ordinateur", rif: "computer" },
      { fr: "chercher", rif: "azokh" },
      { fr: "trouver", rif: "ofikh" },
    ],
  },
  {
    title: "Lieux",
    icon: "location-outline",
    color: "#00829B",
    entries: [
      { fr: "marché", rif: "so9" },
      { fr: "mosquée", rif: "tamzidha" },
      { fr: "pharmacie", rif: "farmassiya" },
      { fr: "magasin", rif: "thanot" },
      { fr: "banque", rif: "lbanka" },
      { fr: "village", rif: "abilaj" },
    ],
  },
  {
    title: "Social",
    icon: "sparkles-outline",
    color: "#C33A72",
    entries: [
      { fr: "fête", rif: "fichta" },
      { fr: "mariage", rif: "ora" },
      { fr: "visite", rif: "assaji" },
      { fr: "invité", rif: "anoji" },
      { fr: "cadeau", rif: "mofajaa" },
    ],
  },
  {
    title: "Adjectifs",
    icon: "color-filter-outline",
    color: "#3F51B5",
    entries: [
      { fr: "grand", rif: "dazira" },
      { fr: "petit", rif: "da9odadh" },
      { fr: "long", rif: "azira" },
      { fr: "court", rif: "a9odadh" },
      { fr: "facile", rif: "yahwan" },
      { fr: "difficile", rif: "i9ssah" },
      { fr: "rapide", rif: "daghya" },
      { fr: "lent", rif: "chway chway" },
      { fr: "bon", rif: "ichna" },
      { fr: "mauvais", rif: "wayihri" },
      { fr: "nouveau", rif: "jdid" },
      { fr: "ancien", rif: "jbari" },
      { fr: "propre", rif: "issfa" },
      { fr: "sale", rif: "yossakh" },
    ],
  },
  {
    title: "Quantité",
    icon: "stats-chart-outline",
    color: "#59612E",
    entries: [
      { fr: "tout", rif: "korchi" },
      { fr: "rien", rif: "walo" },
      { fr: "plus", rif: "kta" },
      { fr: "moins", rif: "9al" },
      { fr: "beaucoup", rif: "atass" },
      { fr: "peu", rif: "drosst" },
    ],
  },
  {
    title: "Prépositions",
    icon: "git-compare-outline",
    color: "#111111",
    entries: [
      { fr: "dans", rif: "di" },
      { fr: "sur", rif: "kh" },
      { fr: "sous", rif: "sado" },
      { fr: "avec", rif: "ag" },
      { fr: "sans", rif: "mbra" },
      { fr: "chez", rif: "gha" },
      { fr: "entre", rif: "ja" },
      { fr: "avant", rif: "9bar" },
      { fr: "après", rif: "amba3d" },
      { fr: "depuis", rif: "zi" },
      { fr: "jusqu'à", rif: "ar" },
    ],
  },
];

const ALL_FILTER = "Tous";

export default function DictionnaireScreen() {
  const { category } = useLocalSearchParams<{ category?: string }>();
  const [query, setQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState(ALL_FILTER);
  const { theme } = useAppSettings();
  const { isWordSaved, toggleWord } = useSavedItems();

  useEffect(() => {
    if (!category) {
      return;
    }

    const categoryName = Array.isArray(category) ? category[0] : category;
    const exists = CATEGORIES.some((item) => item.title === categoryName);

    if (exists) {
      setSelectedCategory(categoryName);
      setQuery("");
    }
  }, [category]);

  const filteredCategories = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    return CATEGORIES.flatMap((category) => {
      const matchesCategory =
        selectedCategory === ALL_FILTER || category.title === selectedCategory;

      if (!matchesCategory) {
        return [];
      }

      const entries = normalizedQuery
        ? category.entries.filter((entry) =>
            `${entry.fr} ${entry.rif}`.toLowerCase().includes(normalizedQuery)
          )
        : category.entries;

      return entries.length > 0 ? [{ ...category, entries }] : [];
    });
  }, [query, selectedCategory]);

  const totalEntries = CATEGORIES.reduce(
    (total, category) => total + category.entries.length,
    0
  );
  const visibleEntries = filteredCategories.reduce(
    (total, category) => total + category.entries.length,
    0
  );

  return (
    <SafeAreaView
      style={[styles.container, { backgroundColor: theme.background }]}
    >
      <TopBar title="Dictionnaire" />

      <ScrollView
        contentContainerStyle={styles.content}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.hero}>
          <View>
            <Text style={styles.heroTitle}>Français - Rifain</Text>
            <Text style={styles.heroSubtitle}>
              {CATEGORIES.length} catégories · {totalEntries} mots
            </Text>
          </View>

          <View style={styles.heroIcon}>
            <Ionicons name="book-outline" size={30} color="#FFFFFF" />
          </View>
        </View>

        <View
          style={[
            styles.searchBox,
            { backgroundColor: theme.surface, borderColor: theme.border },
          ]}
        >
          <Ionicons name="search-outline" size={20} color={theme.muted} />
          <TextInput
            value={query}
            onChangeText={setQuery}
            placeholder="Rechercher un mot"
            placeholderTextColor={theme.muted}
            style={[styles.searchInput, { color: theme.text }]}
          />
          {query.length > 0 && (
            <Pressable
              accessibilityRole="button"
              onPress={() => setQuery("")}
              style={styles.clearButton}
            >
              <Ionicons name="close-circle" size={20} color={theme.muted} />
            </Pressable>
          )}
        </View>

        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.filters}
        >
          <CategoryFilter
            label={ALL_FILTER}
            active={selectedCategory === ALL_FILTER}
            onPress={() => setSelectedCategory(ALL_FILTER)}
            theme={theme}
          />
          {CATEGORIES.map((category) => (
            <CategoryFilter
              key={category.title}
              label={category.title}
              active={selectedCategory === category.title}
              onPress={() => setSelectedCategory(category.title)}
              theme={theme}
            />
          ))}
        </ScrollView>

        <Text style={styles.resultText}>
          {visibleEntries} résultat{visibleEntries > 1 ? "s" : ""}
        </Text>

        {filteredCategories.map((category) => (
          <View key={category.title} style={styles.categoryBlock}>
            <View style={styles.categoryHeader}>
              <View
                style={[
                  styles.categoryIcon,
                  { backgroundColor: category.color },
                ]}
              >
                <Ionicons name={category.icon} size={22} color="#FFFFFF" />
              </View>

              <View style={styles.categoryTitleBlock}>
                <Text style={[styles.categoryTitle, { color: theme.text }]}>
                  {category.title}
                </Text>
                <Text style={[styles.categoryCount, { color: theme.muted }]}>
                  {category.entries.length} mot
                  {category.entries.length > 1 ? "s" : ""}
                </Text>
              </View>
            </View>

            <View
              style={[
                styles.entriesCard,
                { backgroundColor: theme.card, borderColor: theme.border },
              ]}
            >
              {category.entries.map((entry, index) => {
                const wordId = `${category.title}-${entry.fr}-${entry.rif}`;
                const isSaved = isWordSaved(wordId);

                return (
                  <View
                    key={wordId}
                    style={[
                      styles.entryRow,
                      { borderBottomColor: theme.border },
                      index === category.entries.length - 1 && styles.lastEntry,
                    ]}
                  >
                    <Text style={[styles.frenchWord, { color: theme.text }]}>
                      {entry.fr}
                    </Text>
                    <Ionicons
                      name="arrow-forward"
                      size={15}
                      color="#9A96C0"
                      style={styles.entryArrow}
                    />
                    <Text style={[styles.rifWord, { color: theme.accent }]}>
                      {entry.rif}
                    </Text>
                    <Pressable
                      accessibilityRole="button"
                      onPress={() =>
                        toggleWord({
                          id: wordId,
                          fr: entry.fr,
                          rif: entry.rif,
                          category: category.title,
                        })
                      }
                      style={styles.saveButton}
                    >
                      <Ionicons
                        name={isSaved ? "bookmark" : "bookmark-outline"}
                        size={21}
                        color={isSaved ? theme.accent : "#9A96C0"}
                      />
                    </Pressable>
                  </View>
                );
              })}
            </View>
          </View>
        ))}

        {filteredCategories.length === 0 && (
          <View
            style={[
              styles.emptyState,
              { backgroundColor: theme.surface, borderColor: theme.border },
            ]}
          >
            <Ionicons name="search-outline" size={28} color={theme.muted} />
            <Text style={[styles.emptyTitle, { color: theme.text }]}>
              Aucun mot trouvé
            </Text>
            <Text style={[styles.emptyText, { color: theme.muted }]}>
              Essaie un autre mot en français ou en rifain.
            </Text>
          </View>
        )}
      </ScrollView>

      <BottomTab />
    </SafeAreaView>
  );
}

function CategoryFilter({
  label,
  active,
  onPress,
  theme,
}: {
  label: string;
  active: boolean;
  onPress: () => void;
  theme: {
    card: string;
    text: string;
    border: string;
  };
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={[
        styles.filterButton,
        { backgroundColor: theme.card, borderColor: theme.border },
        active && styles.activeFilterButton,
      ]}
    >
      <Text
        style={[
          styles.filterText,
          { color: theme.text },
          active && styles.activeFilterText,
        ]}
      >
        {label}
      </Text>
    </Pressable>
  );
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
    minHeight: 104,
    borderRadius: 8,
    backgroundColor: "#002F63",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 18,
    paddingVertical: 16,
  },

  heroTitle: {
    color: "#FFFFFF",
    fontSize: 23,
    fontWeight: "900",
  },

  heroSubtitle: {
    marginTop: 6,
    color: "#DCE8F7",
    fontSize: 13,
    fontWeight: "700",
  },

  heroIcon: {
    width: 54,
    height: 54,
    borderRadius: 27,
    backgroundColor: "#0A84FF",
    alignItems: "center",
    justifyContent: "center",
  },

  searchBox: {
    height: 48,
    borderWidth: 1,
    borderColor: "#D8D8E0",
    borderRadius: 8,
    marginTop: 16,
    paddingHorizontal: 12,
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#F8F8FA",
  },

  searchInput: {
    flex: 1,
    height: "100%",
    marginLeft: 8,
    color: "#111111",
    fontSize: 15,
    fontWeight: "700",
  },

  clearButton: {
    width: 32,
    height: 32,
    alignItems: "center",
    justifyContent: "center",
  },

  filters: {
    gap: 8,
    paddingTop: 14,
    paddingBottom: 4,
  },

  filterButton: {
    minHeight: 36,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#D8D8E0",
    backgroundColor: "#FFFFFF",
    paddingHorizontal: 12,
    alignItems: "center",
    justifyContent: "center",
  },

  activeFilterButton: {
    borderColor: "#0A84FF",
    backgroundColor: "#0A84FF",
  },

  filterText: {
    color: "#222222",
    fontSize: 13,
    fontWeight: "800",
  },

  activeFilterText: {
    color: "#FFFFFF",
  },

  resultText: {
    marginTop: 12,
    marginBottom: 12,
    color: "#7B78A8",
    fontSize: 12,
    fontWeight: "800",
  },

  categoryBlock: {
    marginBottom: 18,
  },

  categoryHeader: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 8,
  },

  categoryIcon: {
    width: 42,
    height: 42,
    borderRadius: 21,
    alignItems: "center",
    justifyContent: "center",
    marginRight: 10,
  },

  categoryTitleBlock: {
    flex: 1,
  },

  categoryTitle: {
    color: "#000000",
    fontSize: 16,
    fontWeight: "900",
  },

  categoryCount: {
    marginTop: 2,
    color: "#777777",
    fontSize: 11,
    fontWeight: "700",
  },

  entriesCard: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    backgroundColor: "#FFFFFF",
    overflow: "hidden",
  },

  entryRow: {
    minHeight: 45,
    borderBottomWidth: 1,
    borderBottomColor: "#EFEFF4",
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    paddingVertical: 8,
  },

  lastEntry: {
    borderBottomWidth: 0,
  },

  frenchWord: {
    flex: 1,
    color: "#111111",
    fontSize: 14,
    fontWeight: "800",
  },

  entryArrow: {
    marginHorizontal: 10,
  },

  rifWord: {
    flex: 1,
    color: "#002F63",
    fontSize: 14,
    fontWeight: "900",
    textAlign: "right",
  },

  saveButton: {
    width: 38,
    height: 38,
    marginLeft: 6,
    alignItems: "center",
    justifyContent: "center",
  },

  emptyState: {
    borderWidth: 1,
    borderColor: "#E6E6EC",
    borderRadius: 8,
    paddingVertical: 28,
    paddingHorizontal: 18,
    alignItems: "center",
    backgroundColor: "#F8F8FA",
  },

  emptyTitle: {
    marginTop: 8,
    color: "#111111",
    fontSize: 16,
    fontWeight: "900",
  },

  emptyText: {
    marginTop: 4,
    color: "#777777",
    fontSize: 13,
    fontWeight: "700",
    textAlign: "center",
  },
});
