import 'dart:io';
import 'dart:convert';

import 'package:menosi_cli/langify/process.dart';
import 'package:yaml/yaml.dart';

import 'revert/delete_doublon.dart';
import 'revert/revert.dart';

void mainLangifyCommand() {
  final projectDir = Directory.current;
  final translations = <String, String>{};
  final globalTranslations = <String, String>{}; // Pour éviter les doublons
  final pubspecPath = '${projectDir.path}/pubspec.yaml';
  final appName = getAppNameFromPubspec(pubspecPath);

  // Parcourir tous les fichiers Dart dans le dossier lib
  final libDir = Directory('${projectDir.path}/lib');
  if (!libDir.existsSync()) {
    print('Lib directory does not exist');
    return;
  }

  libDir
      .listSync(recursive: true)
      .where((file) => file.path.endsWith('.dart'))
      .forEach((file) {
    processFile(file as File, translations, globalTranslations, appName);
  });

  // Enregistrer les traductions dans fr.json avec un formatage correct
  final jsonFilePath = '${projectDir.path}/assets/locales/fr.json';
  final jsonFile = File(jsonFilePath);
  jsonFile.createSync(recursive: true);
  jsonFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(translations), flush: true);



  // Supprimer les doublons après la réversion
  // Liste des fichiers à traiter
  final dartFiles = projectDir
      .listSync(recursive: true)
      .where((entity) => entity.path.endsWith('.dart'));
      
  for (var entity in dartFiles) {
    if (entity is File) {
      removeDuplicateImports(entity);
    }
  }

  print('Translation process completed.');
}


String getAppNameFromPubspec(String pubspecPath) {
  final file = File(pubspecPath);
  final content = file.readAsStringSync();
  final yamlMap = loadYaml(content);

  // Extraire le nom de l'application
  return yamlMap['name'] ?? 'Nom non trouvé';
}