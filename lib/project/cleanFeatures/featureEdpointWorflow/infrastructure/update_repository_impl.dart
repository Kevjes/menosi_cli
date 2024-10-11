import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void updateRepositoryImpl(
    String featurePath,
    String featureName,
    String entityName,
    Map<String, dynamic> commandJson,
    String endpointConstantName,
    {bool returnValue = true}) {
  final repositoryImpl =
      '$featurePath/infrastructure/repositoriesImpl/${convertToSnakeCase(featureName)}_repository_impl.dart';

  entityName = capitalize(entityName);
  final parameters = analyseParametters(commandJson);

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
    final entityImport =
        "import '../../domain/entities/${convertToSnakeCase(entityName)}.dart';\n";
    final customTypesImports = parameters.values
            .any((type) => type.contains('Command'))
        ? "import '../../application/usecases/${convertToSnakeCase(entityName)}_command.dart';\n"
        : '';

    if (!content.contains(
        'Future<Either<${capitalize(featureName)}Exception, $entityName>> ${transformToLowerCamelCase(entityName)}')) {
      final updatedContent = content.replaceFirst("class", """
${content.contains(entityImport) ? '' : entityImport}${content.contains(baseExceptionImport) ? '' : baseExceptionImport}${content.contains(exceptionImport) ? '' : exceptionImport}${content.contains(constantsImport) ? '' : constantsImport}${content.contains(dartzImport) ? '' : dartzImport}${content.contains(modelImport) ? '' : modelImport}${customTypesImports}
class""").replaceFirst('});', '''});

  @override
  Future<Either<${capitalize(featureName)}Exception, ${returnValue ? "$entityName" : 'bool'}>> ${transformToLowerCamelCase(entityName)}(${parameters.isNotEmpty ? parameters.entries.map((e) => '${e.value} ${e.key}').join(', ') : ''}) async {
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
      print('${yellow}$entityName added to repository implementation${reset}');
    }
  } else {
    print('${red}$repositoryImpl not found${reset}');
  }
}

String generateUrlWithPathParams(
    String urlConstantName, Map<String, dynamic> commandJson) {
  if (commandJson.containsKey('parameters') &&
      commandJson['parameters'].containsKey('query')) {
    final pathParams = commandJson['parameters']['query'];
    String params = pathParams.keys.map((key) {
      String _k = key.startsWith('??') ? key.substring(2) : key;
      return '/\$$_k';
    }).join();
    urlConstantName = '"\${$urlConstantName}$params"';
  }
  return urlConstantName;
}

String generateRequestBody(Map<String, dynamic> commandJson) {
  final buffer = StringBuffer();

  if ((commandJson['method'].toUpperCase() == 'POST' ||
          commandJson['method'].toUpperCase() == 'PUT' ||
          commandJson['method'].toUpperCase() == 'PATCH') &&
      commandJson['parameters'] != null) {
    Map<String, dynamic> params = {};
    if (commandJson['parameters']['body'] != null) {
      params.addAll(commandJson['parameters']['body']);
    }
    if (params.isNotEmpty) {
      buffer.write('body: ');
      buffer.write(_generateRequestBodyContent(params));
      buffer.write(',');
    }
  }

  return buffer.toString();
}

String _generateRequestBodyContent(Map<String, dynamic> bodyParams) {
  final buffer = StringBuffer();
  buffer.write('{');
  bodyParams.forEach((key, value) {
    String _k = key.startsWith('??') ? key.substring(2) : key;

    if (value is Map) {
      // Recursively process nested maps
      buffer.write('\'$_k\': ');
      buffer.write(_generateNestedObject(_k, value as Map<String, dynamic>));
      buffer.write(', ');
    } else if (value is List) {
      // Handle lists if needed
      buffer.write('\'$_k\': ');
      buffer.write(_generateListObject(_k, value));
      buffer.write(', ');
    } else {
      // Simple types
      buffer.write('\'$_k\': $_k, ');
    }
  });
  buffer.write('}');
  return buffer.toString();
}

String _generateNestedObject(
    String objectName, Map<String, dynamic> nestedParams) {
  final buffer = StringBuffer();
  buffer.write('{');
  nestedParams.forEach((key, value) {
    String _k = key.startsWith('??') ? key.substring(2) : key;
    if (value is Map) {
      buffer.write('\'$_k\': ');
      buffer.write(_generateNestedObject('$_k', value as Map<String, dynamic>));
      buffer.write(', ');
    } else if (value is List) {
      buffer.write('\'$_k\': ');
      buffer.write(_generateListObject('$_k', value));
      buffer.write(', ');
    } else {
      buffer.write('\'$_k\': $objectName.$_k, ');
    }
  });
  buffer.write('}');
  return buffer.toString();
}

String _generateListObject(String listName, List<dynamic> listParams) {
  final buffer = StringBuffer();
  buffer.write('[');
  if (listParams.isNotEmpty) {
    var firstElement = listParams.first;
    if (firstElement is Map) {
      buffer.write('$listName.map((item) => ');
      buffer.write(
          _generateNestedObject('item', firstElement as Map<String, dynamic>));
      buffer.write(').toList()');
    } else {
      buffer.write('$listName');
    }
  }
  buffer.write(']');
  return buffer.toString();
}
