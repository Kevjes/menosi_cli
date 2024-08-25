import 'dart:io';

void processFile(File file, Map<String, String> translations,
    Map<String, String> globalTranslations, String pathProjectDir) {
  final content = file.readAsStringSync();

  if (content
      .contains(RegExp(r"\/\/\s*Don't translate me", caseSensitive: false))||content.contains("// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart")) {
    print('Skipping file: ${file.path}');
    return;
  }

  final lines = content.split('\n');
  final updatedLines = <String>[];
  bool hasGetImport = false;
  bool hasMaterialImport = false;
  bool hasModifications = false;

  for (var line in lines) {
    if (line.trim().startsWith('import') || line.trim().startsWith('export') || line.trim().startsWith('//import') || line.trim().startsWith('//export')) {
      updatedLines.add(line);
      continue;
    }

    if (line.contains(
        RegExp(r"\/\/\s*Don't translate line", caseSensitive: false))) {
      updatedLines.add(line);
      continue;
    }

    final regex = RegExp(r'''(["'])(.*?)(\1)''');
    final matches = regex.allMatches(line);

    for (final match in matches) {
      final originalText = match.group(2);
      if (originalText != null && originalText.isNotEmpty) {
        hasModifications = true;

        final variables = <String>[];
        final linksVariables = <String>[];
        String processedText = originalText;

        processedText = processDynamicVariables(processedText, variables);
        processedText = processLinksEmailsPhones(processedText, linksVariables);

        String key;
        if (globalTranslations.containsKey(originalText)) {
          key = globalTranslations[originalText]!;
        } else {
          final fileName = file.uri.pathSegments.last.split('.').first;
          key = generateTranslationKey(fileName, originalText);
          globalTranslations[originalText] = key;
          translations[key] = processedText;
        }

        if (variables.isNotEmpty) {
          line = line.replaceFirst(
            match.group(0) ?? '',
            'LocaleKeys.$key.trArgs([${variables.join(', ')}])',
          );
        }
        if (linksVariables.isNotEmpty) {
          line = line.replaceFirst(
            match.group(0) ?? '',
            'LocaleKeys.$key.trArgs(${linksVariables.map((e) => "'$e'").toList()})',
          );
        } else {
          line = line.replaceFirst(match.group(0) ?? '', 'LocaleKeys.$key.tr');
        }
      }
    }

    updatedLines.add(line);
  }

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

String processDynamicVariables(String originalText, List<String> variables) {
  final variableRegex = RegExp(r'\$\{?([a-zA-Z_][a-zA-Z0-9_\.]*)\}?');
  return originalText.replaceAllMapped(variableRegex, (match) {
    variables.add(match.group(1)!);
    return '%s';
  });
}

String processLinksEmailsPhones(String originalText, List<String> variables) {
  final linkRegex = RegExp(r'http[s]?:\/\/[^\s]+');
  final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
  final phoneRegex = RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b');

  String processedText = originalText;

  processedText = processedText.replaceAllMapped(linkRegex, (match) {
    variables.add(match.group(0)!);
    return '%s';
  });

  processedText = processedText.replaceAllMapped(emailRegex, (match) {
    variables.add(match.group(0)!);
    return '%s';
  });

  processedText = processedText.replaceAllMapped(phoneRegex, (match) {
    variables.add(match.group(0)!);
    return '%s';
  });

  return processedText;
}

String generateTranslationKey(String fileName, String text) {
  String cleanText = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  if (cleanText.length > 30) {
    cleanText = cleanText.substring(0, 30);
  }

  return '${fileName}_$cleanText';
}
