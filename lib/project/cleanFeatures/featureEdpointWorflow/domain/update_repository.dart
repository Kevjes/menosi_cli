import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/project/cleanFeatures/featureEdpointWorflow/domain/entity_generator.dart';

import '../../../../app/functions.dart';

void updateRepository(String featurePath, String featureName, String methodName,
    String entityName, commandJson, {bool returnValue=true}) {
  final repositoryInterface =
      '$featurePath/domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';
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

  if (fileExists(repositoryInterface)) {
    final file = File(repositoryInterface);
    final content = file.readAsStringSync();
    final haveExceptionImport = content.contains(
        "import '../core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';");
    if (!content.contains(
        'Future<Either<${capitalize(featureName)}Exception, ${returnValue?entityName:'bool'}>> $methodName')) {
      final updatedContent = content.replaceFirst("abstract class", """
${haveExceptionImport ? '' : "import '../core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';"}
${returnValue?"import '../entities/${convertToSnakeCase(entityName)}.dart';":''}

abstract class
""").replaceFirst('}', '  Future<Either<${capitalize(featureName)}Exception, ${returnValue?entityName:'bool'}>> $methodName(${parameters.isNotEmpty ? parameters.entries.map((e) => '${e.value} ${e.key}').join(', ') : ''});\n}');
      file.writeAsStringSync(updatedContent);
      print('${yellow}$methodName added to repository interface${reset}');
    } else {
      print(
          '${yellow}$methodName already added in repository interface${reset}');
    }
  } else {
    print('${red}$repositoryInterface not found${reset}');
  }
}
