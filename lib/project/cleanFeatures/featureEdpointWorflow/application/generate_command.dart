import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void generateCommand(
    Map<String, dynamic> commandJson, String entityName, String path) {
  final commandPath =
      '$path/application/useCases/${convertToSnakeCase(entityName)}_command.dart';

  final buffer = StringBuffer();

  Map<String, dynamic> parameters = extractParameters(commandJson);

  if (parameters.isNotEmpty) {
    processCommand("${entityName}Command", parameters, buffer);
    File(commandPath).writeAsStringSync(buffer.toString());
    print(
        '${green}$entityName command and nested commands generated in $commandPath$reset');
  }
}

void processCommand(
    String name, Map<String, dynamic> json, StringBuffer buffer) {
  final commandClassName = transformToUpperCamelCase(name);

  buffer.writeln('class $commandClassName {');
  buffer.writeln();

  generateClassFields(json, buffer, modelType: false, commandType: true);
  buffer.writeln();

  buffer.writeln('  const $commandClassName({');
  generateConstructorParams(json, buffer);
  buffer.writeln('  });');
  buffer.writeln('}');
  buffer.writeln();

  // Traiter les structures imbriquées
  json.forEach((key, value) {
    if (value is Map) {
      processCommand("${key}Command", value as Map<String, dynamic>, buffer);
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      processCommand("${key}Command", value.first, buffer);
    }
  });
}
