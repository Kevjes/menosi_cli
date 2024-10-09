import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void generateCommand(
    Map<String, dynamic> commandJson, String entityName, String path) {
  final commandPath =
      '$path/application/useCases/${convertToSnakeCase(entityName)}_command.dart';

  // Extraire les paramètres d'entrée depuis le JSON
  final parameters = analyseParametters(commandJson);

  final buffer = StringBuffer();

  void processCommand(String name) {
    final commandClassName = capitalize(name);

    buffer
      ..writeln('class $commandClassName {')
      ..writeln();

    generateClassFields(parameters, buffer);

    buffer
      ..writeln()
      ..writeln('  const $commandClassName({');
    generateConstructorParams(parameters, buffer);
    buffer
      ..writeln('  });')
      ..writeln('}')
      ..writeln();
  }

  // Start processing the main entity
  if (parameters.isNotEmpty) {
    processCommand("${entityName}Command");
    File(commandPath).writeAsStringSync(buffer.toString());
    print(
        '${green}$entityName and nested command generated in $commandPath$reset');
  }
}
