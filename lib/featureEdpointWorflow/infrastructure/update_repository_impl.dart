import 'dart:io';

import 'package:menosi_cli/app/constants.dart';

import '../../app/functions.dart';

void updateRepositoryImpl(String featurePath, String featureName,
    String methodName, String entityName) {
  final repositoryImpl =
      '$featurePath/infrastructure/repositories/${convertToSnakeCase(featureName)}_repository_impl.dart';

  entityName = capitalize(entityName);

  if (fileExists(repositoryImpl)) {
    final file = File(repositoryImpl);
    final content = file.readAsStringSync();
    if (!content.contains('Future<Either<${capitalize(featureName)}Exception, $entityName>> $methodName')) {
      final updatedContent = content.replaceFirst("abstract class", """
import '../core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';
import '../entities/${convertToSnakeCase(entityName)}.dart';

abstract class
""").replaceFirst('}', '''
  @override
  Future<Either<${capitalize(featureName)}Exception, $entityName>> $methodName() async {
    try {
      final response = await remoteDataSource.$methodName();
      return Right(response);
    } catch (e) {
      return Left(ServerError());
    }
  }
}''');
      file.writeAsStringSync(updatedContent);
      print('${yellow}$methodName added to repository implementation${reset}');
    }
  } else {
    print('${red}$repositoryImpl not found${reset}');
  }
}
