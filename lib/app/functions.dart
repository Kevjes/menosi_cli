String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String convertToSnakeCase(String input) {
  // Remplace chaque majuscule par un underscore suivi de la lettre en minuscule
  String snakeCase = input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (Match match) => '_${match.group(0)!.toLowerCase()}',
  );

  // Supprime l'éventuel underscore initial (si la première lettre était en majuscule)
  if (snakeCase.startsWith('_')) {
    snakeCase = snakeCase.substring(1);
  }

  return snakeCase;
}
