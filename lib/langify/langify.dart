import 'dart:io';
import 'dart:convert';

import 'package:menosi_cli/langify/process.dart';

void mainLangifyCommand() {
  final projectDir = Directory.current;
  final translations = <String, String>{};

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
    processFile(file as File, translations);
  });

  // Enregistrer les traductions dans fr.json avec un formatage correct
  final jsonFilePath = '${projectDir.path}/assets/translations/fr.json';
  final jsonFile = File(jsonFilePath);
  jsonFile.createSync(recursive: true);
  jsonFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(translations), flush: true);

  print('Translation process completed.');
}
