import 'dart:io';

void processFile(
    File file, Map<String, String> translations, String pathProjectDir) {
  final content = file.readAsStringSync();

  // Vérifier si le fichier contient le commentaire "//Don't translate me"
  if (content.startsWith("//Don't translate me")) {
    print('Skipping file: ${file.path}');
    return;
  }

  // Séparer le contenu en lignes pour traiter les imports
  final lines = content.split('\n');
  final updatedLines = <String>[];
  bool hasGetImport = false;
  bool hasMaterialImport = false;
  bool hasModifications = false;

  // Vérifier les importations existantes
  for (var line in lines) {
    if (line.contains("import 'package:get/get.dart';")) {
      hasGetImport = true;
    }
    if (line.contains("import 'package:$pathProjectDir/generated/locales.g.dart';")) {
      hasMaterialImport = true;
    }
  }

  final regex = RegExp(r'''(["'])(.*?)(\1)''');
  final variableRegex = RegExp(r'\$\{?([a-zA-Z_][a-zA-Z0-9_\.]*)\}?');
  final fileName = file.uri.pathSegments.last.split('.').first;

  for (var line in lines) {
    // Ignorer les lignes contenant 'import' ou 'export'
    if (line.trim().startsWith('import') || line.trim().startsWith('export')) {
      updatedLines.add(line);
      continue;
    }

    final matches = regex.allMatches(line);

    for (final match in matches) {
      final originalText =
          match.group(2); // Le texte capturé est dans le groupe 2

      if (originalText != null && originalText.isNotEmpty) {
        hasModifications = true;
        // Vérifier si le texte contient des variables
        final variableMatches = variableRegex.allMatches(originalText);
        if (variableMatches.isNotEmpty) {
          // Remplacer les variables par %s pour le fichier JSON
          String textForJson = originalText.replaceAll(variableRegex, '%s');
          final key = generateKey(fileName, textForJson);
          translations[key] = textForJson;

          // Extraire les variables pour trArgs
          final variables =
              variableMatches.map((vMatch) => vMatch.group(1)).toList();
          line = line.replaceFirst(match.group(0) ?? '',
              'LocaleKeys.$key.trArgs([${variables.join(', ')}])');
        } else {
          // Texte sans variables
          final key = generateKey(fileName, originalText);
          translations[key] = originalText;
          line = line.replaceFirst(match.group(0) ?? '', 'LocaleKeys.$key.tr');
        }
      }
    }

    updatedLines.add(line);
  }

  // Ajouter les importations manquantes si nécessaire
  if (hasModifications) {
    if (!hasGetImport) {
      updatedLines.insert(0, "import 'package:get/get.dart';");
    }
    if (!hasMaterialImport) {
      updatedLines.insert(
          0, "import 'package:$pathProjectDir/generated/locales.g.dart';");
    }
  }

  final newContent = updatedLines.join('\n');
  file.writeAsStringSync(newContent, flush: true);
}

String generateKey(String fileName, String text) {
  // Nettoyer le texte en remplaçant les caractères non-alphanumériques par des underscores
  String cleanText = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  // Si la longueur de cleanText est inférieure à 30 caractères, on l'utilise tel quel, sinon on utilise les 30 premiers caractères
  if (cleanText.length > 30) {
    cleanText = cleanText.substring(0, 30);
  }

  return '${fileName}_$cleanText';
}
