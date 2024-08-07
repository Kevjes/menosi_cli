
import 'package:menosi_cli/app/functions.dart';

String pageTemplate(String pageName) {
  return '''
import 'package:flutter/material.dart';
import 'controllers/${pageName}_controller.dart';
import 'package:get/get.dart';

class ${capitalize(pageName)}Screen extends GetView<${capitalize(pageName)}Controller> {
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
import '../../presentation/$pageName/controllers/${pageName}_controller.dart';

class ${capitalize(pageName)}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${capitalize(pageName)}Controller>(() => ${capitalize(pageName)}Controller());
  }
}
''';
}