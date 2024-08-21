import 'dart:io';

void processFile(File file, Map<String, String> translations) {
  final content = file.readAsStringSync();

  // Vérifier si le fichier contient le commentaire "//Don't translate me"
  if (content.startsWith("//Don't translate me")) {
    print('Skipping file: ${file.path}');
    return;
  }

  // Séparer le contenu en lignes pour vérifier les imports/exports
  final lines = content.split('\n');
  final updatedLines = <String>[];

  final regex = RegExp(r'''(["'])(.+?)\1''');
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
      if (originalText != null &&
          originalText.isNotEmpty &&
          !translations.containsKey(originalText)) {
        final key = generateKey(fileName, originalText);
        translations[key] = originalText;
        line = line.replaceAll(match.group(0) ?? '', 'LocaleKeys.$key.tr');
      }
    }

    updatedLines.add(line);
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
