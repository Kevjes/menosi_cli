import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void updateRepository(String featurePath, String featureName,
    String entityName, commandJson, {bool returnValue=true}) {
  final repositoryInterface =
      '$featurePath/domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';
  entityName = capitalize(entityName);

  final parameters = analyseParametters(commandJson);

  if (fileExists(repositoryInterface)) {
    final file = File(repositoryInterface);
    final content = file.readAsStringSync();
    final haveExceptionImport = content.contains(
        "import '../core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';");
    if (!content.contains(
        'Future<Either<${capitalize(featureName)}Exception, ${returnValue?entityName:'bool'}>> $entityName')) {
      final updatedContent = content.replaceFirst("abstract class", """
${haveExceptionImport ? '' : "import '../core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';"}
${returnValue?"import '../entities/${convertToSnakeCase(entityName)}.dart';":''}

abstract class
""").replaceFirst('}', '  Future<Either<${capitalize(featureName)}Exception, ${returnValue? entityName:'bool'}>> ${transformToLowerCamelCase(entityName)}(${parameters.isNotEmpty ? parameters.entries.map((e) => '${e.value} ${e.key}').join(', ') : ''});\n}');
      file.writeAsStringSync(updatedContent);
      print('${yellow}$entityName added to repository interface${reset}');
    } else {
      print(
          '${yellow}$entityName already added in repository interface${reset}');
    }
  } else {
    print('${red}$repositoryInterface not found${reset}');
  }
}
