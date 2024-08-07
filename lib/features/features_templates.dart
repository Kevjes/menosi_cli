import 'package:menosi_cli/app/functions.dart';

String pageTemplate(String pageName) {
  return '''
import 'package:flutter/material.dart';
import 'controllers/${pageName}_controller.dart';
import 'package:get/get.dart';

class ${capitalize(pageName)}Screen extends GetView<${capitalize(pageName)}ControllerController> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${capitalize(pageName)} Screen'),
      ),
      body: Center(
        child: Text('Welcome to ${capitalize(pageName)} Screen'),
      ),
    );
  }
}
''';
}

String controllerTemplate(String pageName) {
  return '''
import 'package:get/get.dart';

class ${capitalize(pageName)}Controller extends GetxController {
  // Controller logic
}
''';
}

String bindingTemplate(String pageName) {
  return '''
import 'package:get/get.dart';
import '../../presentation/enrollement/controllers/${pageName}_controller.dart';

class ${capitalize(pageName)}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${capitalize(pageName)}Controller>(() => ${capitalize(pageName)}Controller());
  }
}
''';
}

String routesTemplate(String featureName) {
  return '''
class ${capitalize(featureName)}Routes {
  static const String HOME = '/${featureName}';
  // Add other routes here
}
''';
}

String navigationTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../presentation/views/${featureName}_screen.dart';
import '${featureName}_routes.dart';

class ${capitalize(featureName)}Nav {
  static List<GetPage> routes = [
    GetPage(
      name: ${capitalize(featureName)}Routes.HOME,
      page: () => ${capitalize(featureName)}Screen(),
    ),
    // Add other routes here
  ];
}
''';
}

String injectionTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../../presentation/enrollement/presentation/controllers/${featureName}_controller.dart';

class ${capitalize(featureName)}DependenciesInjection {
  static void init() {
    Get.lazyPut<${capitalize(featureName)}Controller>(() => ${capitalize(featureName)}Controller());
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
