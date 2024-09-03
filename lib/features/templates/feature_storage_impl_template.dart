import 'package:menosi_cli/app/functions.dart';

String repositoryImplTemplate(String featureName) {
  return """
//Don't translate me
import '../../domain/localStorage/${convertToSnakeCase(featureName)}_local_storage.dart';
import '../../../../core/services/localServices/local_storage_service.dart';

class ${capitalize(featureName)}LocalStorageImpl implements ${capitalize(featureName)}LocalStorage {
  final LocalStorageService localStorageService;

  ${capitalize(featureName)}RepositoryImpl({
    required this.localStorageService,
  });

  //Add methods here

}
""";
}
