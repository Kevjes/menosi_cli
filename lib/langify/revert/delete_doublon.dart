import 'dart:collection';
import 'dart:io';

void removeDuplicateImports(File file) {
  final content = file.readAsLinesSync();
  final uniqueImports = LinkedHashSet<String>();
  final updatedLines = <String>[];

  for (var line in content) {
    if (line.trim().startsWith('import') ||
        line.trim().startsWith('export') ||
        line.trim().startsWith('//import') ||
        line.trim().startsWith('//export')) {
      // Ajouter uniquement les imports uniques
      if (!uniqueImports.contains(line.trim())) {
        uniqueImports.add(line.trim());
        updatedLines.add(line);
      }
    } else {
      updatedLines.add(line); // Ajouter les autres lignes sans changement
    }
  }

  final newContent = updatedLines.join('\n');
  file.writeAsStringSync(newContent, flush: true);
}
