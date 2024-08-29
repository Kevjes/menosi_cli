import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

import '../domain/entity_generator.dart';

void generateUseCase(String methodName, String featureName, String entityName,
    String path, Map<String, dynamic> commandJson,
    {bool returnValue = true}) {
  final useCasePath =
      '$path/application/usecases/${convertToSnakeCase(methodName)}_usecase.dart';

  if (!fileExists(useCasePath)) {
    final buffer = StringBuffer()
      ..writeln('//Don\'t translate me')
      ..writeln('import \'package:dartz/dartz.dart\';')
      ..writeln(
          'import \'../../domain/core/exceptions/${convertToSnakeCase(featureName)}_exception.dart\';')
      ..writeln(
          "import '../../domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';")
      ..writeln(returnValue
          ? "import '../../domain/entities/${convertToSnakeCase(entityName)}.dart'\n"
          : '')
      ..writeln('class ${capitalize(methodName)}UseCase {')
      ..writeln('  final ${capitalize(featureName)}Repository repository;')
      ..writeln()
      ..writeln('  ${capitalize(methodName)}UseCase(this.repository);')
      ..writeln();

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

    // Générer la signature de la méthode `call`
    buffer.write(
        '  Future<Either<${capitalize(featureName)}Exception, ${returnValue ? entityName : 'bool'}>> call(');
    if (parameters.isNotEmpty) {
      buffer.write(parameters.entries
          .map((e) => '${e.value} ${transformToLowerCamelCase(e.key)}')
          .join(', '));
    }
    buffer.writeln(') async {');

    // Générer l'appel au repository
    buffer.write('    return await repository.$methodName(');
    if (parameters.isNotEmpty) {
      buffer.write(parameters.keys
          .map((e) => transformToLowerCamelCase(e))
          .toList()
          .join(', '));
    }
    buffer.writeln(');');

    buffer
      ..writeln('  }')
      ..writeln('}');

    File(useCasePath).writeAsStringSync(buffer.toString());
    print(
        '$green${capitalize(methodName)}UseCase generated at $useCasePath$reset');
  } else {
    print(
        '$yellow${capitalize(methodName)}UseCase already exists at $useCasePath$reset');
  }
}
