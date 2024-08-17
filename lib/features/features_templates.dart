import 'package:menosi_cli/app/functions.dart';

String privateRoutesTemplate(String featureName) {
  return '''
class ${capitalize(featureName)}PrivateRoutes {
  static const String home = '/$featureName';
  // Add other privates routes here
}
''';
}

String publicRoutesTemplate(String featureName) {
  return '''
import 'private/${featureName}_private_routes.dart';

class ${capitalize(featureName)}PublicRoutes {
  static const home = ${capitalize(featureName)}PrivateRoutes.home;
  // Add other publics routes here
}

''';
}

String privatePagesTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../../../../core/navigation/routes/features_routes.dart';
import '../../presentation/$featureName/${featureName}_screen.dart';
import '../bindings/${featureName}_controller_binding.dart';
import '${featureName}_private_routes.dart';

class ${capitalize(featureName)}PrivatePages implements FeaturePages {
  @override
  List<GetPage>  getPages() => [
    GetPage(
      name: ${capitalize(featureName)}PrivateRoutes.home,
      page: () => ${capitalize(featureName)}Screen(),
      binding: ${capitalize(featureName)}ControllerBinding(),
    ),
    // Add other routes here
  ];
}
''';
}

String injectionTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../presentation/$featureName/controllers/${featureName}_controller.dart';

class ${capitalize(featureName)}DependenciesInjection {
  static void init() {
    // Get.Put(${capitalize(featureName)}Controller(Get.find()));
    // Add other dependencies here
  }
}
''';
}

String testTemplate(String featureName) {
  return '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('${capitalize(featureName)} Tests', () {
    test('Initial Test', () {
      // Write your test here
    });
  });
}
''';
}
