import 'dart:convert';
import 'dart:io';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String convertToSnakeCase(String input) {
  if (RegExp(r'^[a-z]+(_[a-z]+)*$').hasMatch(input)) {
    return input;
  }
  final regex = RegExp(r'(?<!^)(?=[A-Z])');
  return input
      .replaceAllMapped(regex, (match) => "_${match.group(0)}")
      .toLowerCase();
}

String transformToUpperCamelCase(String input) {
  if (RegExp(r'^[A-Z][a-z]+([A-Z][a-z]+)*$').hasMatch(input)) {
    return input;
  }
  return input.split('_').map((word) {
    if (RegExp(r'^[A-Z][a-z]+([A-Z][a-z]+)*$').hasMatch(word)) {
      return word;
    }
    return word != '' ? word[0].toUpperCase() + word.substring(1) : '';
  }).join('');
}

String transformToLowerCamelCase(String input) {
  final text = transformToUpperCamelCase(input);
  return text[0].toLowerCase() + text.substring(1);
}

bool fileExists(String path) {
  return File(path).existsSync();
}

Map<String, dynamic> readJson(String path) {
  final file = File(path);
  return jsonDecode(file.readAsStringSync());
}
