import 'package:menosi_cli/app/functions.dart';

String repositoryImplTemplate(String featureName) {
  return """
import '../../domain/core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';
import '../../domain/core/utils/${convertToSnakeCase(featureName)}_constants.dart';
import '../../domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';
import '../../../../core/services/localServices/local_storage_service.dart';
import '../../../../core/services/networkServices/network_service.dart';

class ${capitalize(featureName)}RepositoryImpl implements ${capitalize(featureName)}Repository {
  final NetworkService networkService;
  final LocalStorageService localStorageService;

  ${capitalize(featureName)}RepositoryImpl({
    required this.networkService,
    required this.localStorageService,
  });

  //Add methods here

}
""";
}
