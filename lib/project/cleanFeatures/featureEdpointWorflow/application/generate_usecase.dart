import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

import '../functions.dart';


void generateUseCase( String featureName, String entityName,
    String path, Map<String, dynamic> commandJson,
    {bool returnValue = true}) {
  final useCasePath =
      '$path/application/usecases/${convertToSnakeCase(entityName)}_usecase.dart';

  if (!fileExists(useCasePath)) {
    // Extraire les paramètres d'entrée depuis le JSON
    final parameters = analyseParametters(commandJson);
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
        '    return await repository.${transformToLowerCamelCase(entityName)}(${parameters.keys.isNotEmpty ? parameters.keys.map((key) => 'command.${transformToLowerCamelCase(key)}').join(',') : ""});');
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
