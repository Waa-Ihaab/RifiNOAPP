# Rifino Flutter App

Base Flutter pour reconstruire Rifino sur Windows, Android et iOS.

## Important

Tu peux developper et tester Android sur Windows. Pour publier sur l'App Store, il faudra quand meme un Mac, Xcode ou un service cloud Mac pour signer et generer le build iOS.

## Installation

1. Installe Flutter: https://docs.flutter.dev/get-started/install/windows
2. Dans ce dossier, lance:

```bash
flutter pub get
flutter create --platforms=android,ios .
flutter run
```

Si tu veux tester sur Windows desktop:

```bash
flutter create --platforms=windows .
flutter run -d windows
```

## Structure

- `lib/app`: app root, navigation, shell principal.
- `lib/core/theme`: couleurs, tailles, styles texte, theme Material.
- `lib/features`: ecrans par domaine fonctionnel.
- `lib/shared/widgets`: composants UI reutilisables.
- `lib/shared/models`: modeles partages.
- `lib/shared/services`: services API, auth, stockage.
- `assets`: images, icones, ressources statiques.

