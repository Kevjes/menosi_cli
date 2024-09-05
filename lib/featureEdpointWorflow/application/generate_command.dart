import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../app/functions.dart';

void generateCommand(
    Map<String, dynamic> commandJson, String entityName, String path) {
  final commandPath =
      '$path/application/useCases/${convertToSnakeCase(entityName)}_command.dart';

  // Extraire les paramètres d'entrée depuis le JSON
  final parameters = <String, String>{};

  if (commandJson.containsKey('parameters')) {
    final params = commandJson['parameters'];
    if (params.containsKey('path')) {
      parameters.addAll(params['path'].map<String, String>((key, value) =>
          MapEntry<String, String>(key as String, getType(value))));
    }
    if (params.containsKey('query')) {
      parameters.addAll(params['query'].map<String, String>((key, value) =>
          MapEntry<String, String>(key as String, getType(value))));
    }
    if (params.containsKey('body')) {
      parameters.addAll(params['body'].map<String, String>((key, value) =>
          MapEntry<String, String>(key as String, getType(value))));
    }
  }

  final buffer = StringBuffer();

  void processCommand(String name) {
    final commandClassName = capitalize(name);

    buffer
      ..writeln('class $commandClassName {')
      ..writeln();

    parameters.forEach((key, value) {
      buffer.writeln(
          '  final ${getType(value)} ${transformToLowerCamelCase(key)};');
    });

    buffer
      ..writeln()
      ..writeln('  const $commandClassName({')
      ..writeln(parameters.keys.map((key) {
        return '    required this.${transformToLowerCamelCase(key)},';
      }).join('\n'))
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

String getType(dynamic jsonType) {
  if (jsonType is String) {
    return 'String';
  } else if (jsonType is int) {
    return 'int';
  } else if (jsonType is double) {
    return 'double';
  } else if (jsonType is bool) {
    return 'bool';
  } else {
    return 'dynamic';
  }
}
