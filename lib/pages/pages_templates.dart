import 'package:menosi_cli/app/functions.dart';

String pageTemplate(String pageName) {
  return '''
import 'package:flutter/material.dart';
import 'controllers/${convertToSnakeCase(pageName)}_controller.dart';
import 'package:get/get.dart';

class ${capitalize(pageName)}Screen extends GetView<${capitalize(pageName)}Controller> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('${capitalize(pageName)} Screen'),
      ),
      body: const Center(
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
import '../../../../../core/navigation/app_navigation.dart';

class ${capitalize(pageName)}Controller extends GetxController {
  final AppNavigation _appNavigation;
  ${capitalize(pageName)}Controller(this._appNavigation);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
''';
}

String bindingTemplate(String pageName) {
  return '''
import 'package:get/get.dart';
import '../../presentation/$pageName/controllers/${convertToSnakeCase(pageName)}_controller.dart';

class ${capitalize(pageName)}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${capitalize(pageName)}Controller>(() => ${capitalize(pageName)}Controller(Get.find()));
  }
}
''';
}