import 'package:menosi_cli/app/functions.dart';

String featureDependencesTemplate(String featureName, String snakeFeatureName) {
  return """
import 'package:get/get.dart';

import '../domain/repositories/${snakeFeatureName}_repository.dart';
import '../domain/localStorage/${snakeFeatureName}_local_storage.dart';
import '../infrastructure/repositoriesImpl/${snakeFeatureName}_repository_impl.dart';
import '../infrastructure/localStorageImpl/${snakeFeatureName}_local_storage_impl.dart';

class ${capitalize(featureName)}Dependencies {
  static void init() {
    Get.lazyPut<${capitalize(featureName)}Repository>(() => ${capitalize(featureName)}RepositoryImpl(
        networkService: Get.find()));
    Get.lazyPut<${capitalize(featureName)}LocalStorage>(() => ${capitalize(featureName)}LocalStorageImpl(
        localStorageService: Get.find()));
  }
}


""";
}
