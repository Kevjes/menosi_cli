import 'dart:io';

import 'revert.dart';

void mainLangifyRevert() {
  // Chemin vers le fichier fr.json
  final projectDir = Directory.current;
  final pathToJson = '${projectDir.path}/assets/locales/fr.json';
  final translations = loadTranslations(pathToJson);

  // Liste des fichiers à traiter
  final dartFiles = projectDir.listSync(recursive: true).where((entity) => entity.path.endsWith('.dart'));

  for (var entity in dartFiles) {
    if (entity is File) {
      revertTranslationsInFile(entity, translations, projectDir.path.split('\\').last);
    }
  }

  print('Chemin retour effectué avec succès.');
}
