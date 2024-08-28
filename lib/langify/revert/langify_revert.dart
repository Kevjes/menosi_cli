import 'dart:io';

import 'package:menosi_cli/langify/langify.dart';

import 'delete_doublon.dart';
import 'revert.dart';

void mainLangifyRevert() {
  // Chemin vers le fichier fr.json
  final projectDir = Directory.current;
  final pathToJson = '${projectDir.path}/assets/locales/fr.json';
  final translations = loadTranslations(pathToJson);
  if (translations == null) {
    print('Error: fr.json file not found in assets/locales. Exiting...');
    print('Usage: menosi langify to generate fr.json');
    return;
  }else if( translations.isEmpty ){
    print('Error: fr.json file is empty. Exiting...');
    print('Usage: menosi langify to generate fr.json');
    return;
  }
  final pubspecPath = '${projectDir.path}/pubspec.yaml';
  final appName = getAppNameFromPubspec(pubspecPath);

  // Liste des fichiers à traiter
  final dartFiles = projectDir
      .listSync(recursive: true)
      .where((entity) => entity.path.endsWith('.dart'));

  for (var entity in dartFiles) {
    if (entity is File) {
      revertTranslationsInFile(entity, translations, appName);
    }
  }

  // Supprimer les doublons après la réversion
  for (var entity in dartFiles) {
    if (entity is File) {
      removeDuplicateImports(entity);
    }
  }

  print('Chemin retour effectué avec succès.');
}
