import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/project/cleanFeatures/featureEdpointWorflow/domain/entity_generator.dart';

import '../../../../app/functions.dart';

void updateRepositoryImpl(
    String featurePath,
    String featureName,
    String methodName,
    String entityName,
    Map<String, dynamic> commandJson,
    String endpointConstantName,
    {bool returnValue = true}) {
  final repositoryImpl =
      '$featurePath/infrastructure/repositoriesImpl/${convertToSnakeCase(featureName)}_repository_impl.dart';

  entityName = capitalize(entityName);
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

  if (fileExists(repositoryImpl)) {
    final file = File(repositoryImpl);
    final content = file.readAsStringSync();
    final exceptionImport =
        "import '../../domain/core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';\n";
    final constantsImport =
        "import '../../domain/core/utils/${convertToSnakeCase(featureName)}_constants.dart';\n";
    final dartzImport = "import 'package:dartz/dartz.dart';\n";
    final baseExceptionImport =
        "import '../../../../core/exceptions/base_exception.dart';\n";
    final modelImport = returnValue
        ? "import '../models/${convertToSnakeCase(entityName)}_model.dart';\n"
        : '';
    final entityImport = "import '../../domain/entities/${convertToSnakeCase(entityName)}.dart';\n";
    if (!content.contains(
        'Future<Either<${capitalize(featureName)}Exception, $entityName>> $methodName')) {
      final updatedContent = content.replaceFirst("class", """
${content.contains(entityImport) ? '' : entityImport}${content.contains(baseExceptionImport) ? '' : baseExceptionImport}${content.contains(exceptionImport) ? '' : exceptionImport}${content.contains(constantsImport) ? '' : constantsImport}${content.contains(dartzImport) ? '' : dartzImport}${content.contains(modelImport) ? '' : modelImport}
class""").replaceFirst('});', '''});

  @override
  Future<Either<${capitalize(featureName)}Exception, ${returnValue ? "$entityName" : 'bool'}>> $methodName(${parameters.isNotEmpty ? parameters.entries.map((e) => '${e.value} ${e.key}').join(', ') : ''}) async {
    try {
      final response = await networkService.${(commandJson['method'] as String).toLowerCase()}(
        ${generateUrlWithPathParams("${capitalize(featureName)}Constants.$endpointConstantName", commandJson)},
        ${generateRequestBody(commandJson)}
      );
      return Right(${returnValue ? "${entityName}Model.fromJson(response).toEntity()" : 'true'});
    } on BaseException catch (e) {
      return Left(${transformToUpperCamelCase(featureName)}Exception(e.message));
    }
  }
''');
      file.writeAsStringSync(updatedContent);
      print('${yellow}$methodName added to repository implementation${reset}');
    }
  } else {
    print('${red}$repositoryImpl not found${reset}');
  }
}

String generateUrlWithPathParams(
    String urlConstantName, Map<String, dynamic> commandJson) {
  if (commandJson.containsKey('parameters') &&
      commandJson['parameters'].containsKey('query')) {
    final queries = commandJson['parameters']['query'];
    String params = "";
    queries.forEach((key, value) {
      params = "$params/\$$key";
    });
    urlConstantName = '"\${$urlConstantName}$params"';
  }
  return urlConstantName;
}

String generateRequestBody(Map<String, dynamic> commandJson) {
  final buffer = StringBuffer();

  if (commandJson['method'].toUpperCase() == 'POST' ||
      commandJson['method'].toUpperCase() == 'PUT' ||
      commandJson['method'].toUpperCase() == 'PATCH') {
    if (commandJson['parameters']['body'] != null) {
      buffer.write('body: {');
      commandJson['parameters']['body'].forEach((key, _) {
        buffer.write('\'$key\': $key, ');
      });
      buffer.write('},');
    }
  }

  return buffer.toString();
}
