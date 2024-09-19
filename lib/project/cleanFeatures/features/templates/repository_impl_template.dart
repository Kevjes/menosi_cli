import 'package:menosi_cli/app/functions.dart';

String repositoryImplTemplate(String featureName) {
  return """
//Don't translate me
import '../../domain/repositories/${convertToSnakeCase(featureName)}_repository.dart';
import '../../../../core/services/networkServices/network_service.dart';

class ${capitalize(featureName)}RepositoryImpl implements ${capitalize(featureName)}Repository {
  final NetworkService networkService;

  ${capitalize(featureName)}RepositoryImpl({
    required this.networkService,
  });

  //Add methods here

}
""";
}
