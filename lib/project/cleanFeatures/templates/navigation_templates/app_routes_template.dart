String appRoutesTemplate() {
  return '''
import '../../../features/home/navigation/home_public_routes.dart';
import '../../utils/app_constants.dart';

class AppRoutes {
  static String get initialRoute => splash;
  
  //Home publics routes
  static const home = HomePublicRoutes.home;
  
  //Other publics routes
  static const splash = AppConstants.splashScreen;
  static const notFoundPage = AppConstants.notFoundScreen;
}

''';
}
