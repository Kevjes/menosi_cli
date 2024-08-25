String dependencesTemplate() {
  return '''
//Don't translate me
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../navigation/app_navigation.dart';
import '../navigation/getx_navigation_impl.dart';
import '../navigation/routes/app_pages.dart';
import '../navigation/routes/app_routes.dart';
import '../../features/home/navigation/private/home_private_navigation.dart';
import '../services/localServices/get_storage_local_storage_services.dart';
import '../services/localServices/local_storage_services.dart';
import '../services/networkServices/http_network_services.dart';
import '../services/networkServices/network_services.dart';
import '../../features/home/dependences/home_dependencies_injection.dart';

class AppDependency {
  static Future<void> init() async {

    // Initialize GetStorage
    await GetStorage.init();

    // initialize all pages
    final featuresPages = [
      HomePages(),
      //Add features pages here
    ];
    Get.lazyPut(() => AppPages(featuresPages));

    //initialize AppNavigation
    Get.lazyPut<AppNavigation>(
        () => GetXNavigationImpl(AppRoutes.notFoundPage));

    //initialize Views

    // Réseau
    Get.lazyPut<NetworkService>(() => HttpNetworkService());

    // Stockage local
    Get.lazyPut<LocalStorageService>(() => GetStorageService());

    //Chargement des dependances de features
    HomeDependenciesInjection.init();
  }
}

''';
}
