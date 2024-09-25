import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

import '../domain/entity_generator.dart';

void generateUseCase( String featureName, String entityName,
    String path, Map<String, dynamic> commandJson,
    {bool returnValue = true}) {
  final useCasePath =
      '$path/application/usecases/${convertToSnakeCase(entityName)}_usecase.dart';

  if (!fileExists(useCasePath)) {
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
    final buffer = StringBuffer()
      ..writeln('//Don\'t translate me')
      ..writeln(parameters.isNotEmpty
          ? "import '${convertToSnakeCase(entityName)}_command.dart';"
          : '')
      ..writeln('import \'package:dartz/dartz.dart\';')
      ..writeln(
          'import \'../../domain/core/exceptions/${convertToSnakeCase(featureName)}_exception.dart\';')
      ..writeln(
          "import '../../domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';")
      ..writeln(returnValue
          ? "import '../../domain/entities/${convertToSnakeCase(entityName)}.dart';\n"
          : '')
      ..writeln('class ${capitalize(entityName)}UseCase {')
      ..writeln('  final ${capitalize(featureName)}Repository repository;')
      ..writeln()
      ..writeln('  ${capitalize(entityName)}UseCase(this.repository);')
      ..writeln();

    // Générer la signature de la méthode `call`
    buffer.writeln(
        '  Future<Either<${capitalize(featureName)}Exception, ${returnValue ? entityName : 'bool'}>> call(${parameters.keys.isNotEmpty ? "${capitalize(entityName)}Command command" : ""}) async {');

    // Générer l'appel au repository
    buffer.write(
        '    return await repository.${transformToLowerCamelCase(entityName)}(${parameters.keys.isNotEmpty ? parameters.keys.map((key) => '        command.${transformToLowerCamelCase(key)}').join(',\n') : ""});');
    buffer
      ..writeln('  }')
      ..writeln('}');

    File(useCasePath).writeAsStringSync(buffer.toString());
    print(
        '$green${capitalize(entityName)}UseCase generated at $useCasePath$reset');
  } else {
    print(
        '$yellow${capitalize(entityName)}UseCase already exists at $useCasePath$reset');
  }
}
