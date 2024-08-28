import 'dart:convert';
import 'dart:io';

void revertTranslationsInFile(
    File file, Map<String, String> translations, String projectName) {
  final content = file.readAsStringSync();
  final updatedLines = <String>[];

  final lines = content.split('\n');
  bool hasModifications = false;

  for (var line in lines) {
    // Retirer les importations spécifiques à la traduction
    if (line
        .contains("import 'package:$projectName/generated/locales.g.dart';")) {
      hasModifications = true;
      continue; // Ignorer cette ligne
    }

    for (var entry in translations.entries) {
      final key = entry.key;
      final value = entry.value;
      final pattern = "LocaleKeys.$key.tr";
      final patternArgs = "LocaleKeys.$key.trArgs";

      if (line.contains(patternArgs)) {
        // Extraire les arguments passés à trArgs
        final argsStart = line.indexOf('[') + 1;
        final argsEnd = line.indexOf(']');
        final argsString = line.substring(argsStart, argsEnd);
        final args = argsString.split(',').map((arg) => arg.trim()).toList();

        // Remplacer chaque %s dans la valeur d'origine par les arguments
        var restoredValue = value;
        for (var arg in args) {
          restoredValue = restoredValue.replaceFirst(
              '%s', hasSingleQuotes(arg) ? removeSingleQuotes(arg) : "\$$arg");
        }

        // Remplacer l'appel trArgs par la valeur restaurée
        line = line.replaceFirst(
            "LocaleKeys.$key.trArgs([$argsString])", '"$restoredValue"');
        hasModifications = true;
      } else if (line.contains(pattern)) {
        // Remplacement direct des clés sans variables
        line = line.replaceFirst(pattern, '"$value"');
        hasModifications = true;
      }
    }

    updatedLines.add(line);
  }

  if (hasModifications) {
    final newContent = updatedLines.join('\n');
    file.writeAsStringSync(newContent, flush: true);
  }
}

bool hasSingleQuotes(String input) {
  return input.startsWith("'") && input.endsWith("'");
}

String removeSingleQuotes(String input) {
  if (input.startsWith("'") && input.endsWith("'")) {
    return input.substring(1, input.length - 1);
  }
  return input;
}

Map<String, String>? loadTranslations(String pathToJson) {
  try {
    final file = File(pathToJson);
    final jsonContent = file.readAsStringSync();
    return Map<String, String>.from(jsonDecode(jsonContent));
  } catch (e) {
    return null;
  }
}
