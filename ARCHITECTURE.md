# Architecture Rifino Flutter

## Principe

L'application suit une architecture simple et scalable:

- `app`: configuration globale de l'application.
- `core`: theme, constantes, helpers transverses.
- `features`: fonctionnalites organisees par ecran ou domaine.
- `shared`: widgets, models et services reutilisables.

## Navigation

`RifinoApp` affiche `AppShell`, qui gere trois etats:

- onboarding
- login
- main

Cette navigation locale est volontairement simple pour demarrer. Quand l'app grandira, tu pourras passer a `go_router`.

## Theme

Le theme est centralise dans `lib/core/theme`.
Chaque ecran utilise les couleurs, espacements et composants partages pour garder une interface coherente.

## Prochaines etapes

1. Installer Flutter sur Windows.
2. Generer les dossiers natifs avec `flutter create --platforms=android,ios .`.
3. Brancher les vraies APIs Rifino.
4. Ajouter l'authentification reelle.
5. Ajouter les assets, icones launcher et ecrans App Store.

