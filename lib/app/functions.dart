String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String convertToSnakeCase(String input) {
  if (RegExp(r'^[a-z]+(_[a-z]+)*$').hasMatch(input)) {
    // Le texte est déjà sous le format "bonjour_toma_tabo"
    return input;
  }

  final regex = RegExp(r'(?<!^)(?=[A-Z])');
  return input
      .replaceAllMapped(regex, (match) => "_${match.group(0)}")
      .toLowerCase();
}

String transformToUpperCamelCase(String input) {
  if (RegExp(r'^[A-Z][a-z]+([A-Z][a-z]+)*$').hasMatch(input)) {
    // Le texte est déjà sous le format "BonjourTomaTabo"
    return input;
  }

  return input.split('_').map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join('');
}

String transformToLowerCamelCase(String input) {
  if (RegExp(r'^[a-z]+([A-Z][a-z]+)*$').hasMatch(input)) {
    // Le texte est déjà sous le format "bonjourTomaTabo"
    return input;
  }

  List<String> words = input.split('_').map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();

  // La première lettre du premier mot reste en minuscule
  words[0] = words[0][0].toLowerCase() + words[0].substring(1);

  return words.join('');
}
