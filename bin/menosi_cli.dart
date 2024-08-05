import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  final parser = ArgParser();

  // Sub-command for creating a feature
  final createCmd = parser.addCommand('create')
    ..addOption('name',
        abbr: 'n', help: 'Name of the feature', defaultsTo: 'feature');

  // Sub-command for creating a page within a feature
  final createPageCmd = parser.addCommand('create_page')
    ..addOption('name', abbr: 'n', help: 'Name of the page', defaultsTo: 'page')
    ..addOption('feature',
        abbr: 'f',
        help: 'Name of the feature for the page',
        defaultsTo: 'authentication');

  final results = parser.parse(arguments);

  if (results.command?.name == 'create') {
    final featureName = results.command?['name'] ?? 'feature';
    createFeature(featureName);
  } else if (results.command?.name == 'create_page') {
    final pageName = results.command?['name'] ?? 'page';
    final featureName = results.command?['feature'] ?? 'authentication';
    createPage(featureName, pageName);
  } else {
    print('Usage: menosicli create --name <feature_name>');
    print(
        'Usage: menosicli create_page --name <page_name> --feature <feature_name>');
  }
}

void createFeature(String featureName) {
  final currentDir = Directory.current.path;

  // Define the paths for the new feature
  final featurePath = p.join(currentDir, 'lib', 'features', featureName);
  final testFeaturePath = p.join(currentDir, 'test', 'features', featureName);
  final injectionFilePath = p.join(
      currentDir, 'lib', 'core', 'dependences', 'dependencies_injection.dart');

  // Create the directory structure
  Directory(p.join(featurePath, 'presentation', 'views'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'presentation', 'controllers'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'presentation', 'bindings'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'navigation')).createSync(recursive: true);
  Directory(p.join(featurePath, 'dependences')).createSync(recursive: true);
  Directory(p.join(featurePath, 'tests')).createSync(recursive: true);

  // Create basic files with templates
  File(p.join(
          featurePath, 'presentation', 'views', '${featureName}_screen.dart'))
      .writeAsStringSync(_pageTemplate(featureName));
  File(p.join(featurePath, 'presentation', 'controllers',
          '${featureName}_controller.dart'))
      .writeAsStringSync(_controllerTemplate(featureName));
  File(p.join(featurePath, 'navigation', 'bindings',
          '${featureName}_controller_binding.dart'))
      .writeAsStringSync(_bindingTemplate(featureName));
  File(p.join(featurePath, 'navigation', '${featureName}_routes.dart'))
      .writeAsStringSync(_routesTemplate(featureName));
  File(p.join(featurePath, 'navigation', '${featureName}_navigation.dart'))
      .writeAsStringSync(_navigationTemplate(featureName));
  File(p.join(featurePath, 'dependences',
          '${featureName}_dependencies_injection.dart'))
      .writeAsStringSync(_injectionTemplate(featureName));

  // Create test file
  Directory(testFeaturePath).createSync(recursive: true);
  File(p.join(testFeaturePath, '${featureName}_test.dart'))
      .writeAsStringSync(_testTemplate(featureName));

  // Update global dependencies injection file
  final injectionFile = File(injectionFilePath);
  final injectionFileContent = injectionFile.readAsStringSync();
  final updatedContent = injectionFileContent.replaceFirst(
      '}', "  ${_capitalize(featureName)}DependenciesInjection.init();\n}");
  injectionFile.writeAsStringSync(updatedContent);

  print('Feature "$featureName" created successfully.');
}

void createPage(String featureName, String pageName) {
  final currentDir = Directory.current.path;

  // Define the paths for the new page within the feature
  final pagePath = p.join(
      currentDir, 'lib', 'features', featureName, 'presentation', pageName);
  final controllerPath = p.join(currentDir, 'lib', 'features', featureName,
      'presentation', pageName, 'controllers');
  final bindingPath = p.join(
      currentDir, 'lib', 'features', featureName, 'navigation', 'bindings');
  final navigationFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', '${featureName}_navigation.dart');
  final routesFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', '${featureName}_routes.dart');

  // Create the directory structure
  Directory(pagePath).createSync(recursive: true);
  Directory(controllerPath).createSync(recursive: true);
  Directory(bindingPath).createSync(recursive: true);

  // Create basic files with templates
  File(p.join(pagePath, '${pageName}_screen.dart'))
      .writeAsStringSync(_pageTemplate(pageName));
  File(p.join(controllerPath, '${pageName}_controller.dart'))
      .writeAsStringSync(_controllerTemplate(pageName));
  File(p.join(bindingPath, '${pageName}_controller_binding.dart'))
      .writeAsStringSync(_bindingTemplate(pageName));

  // Update routes file
  final routesFile = File(routesFilePath);
  final routesFileContent = routesFile.readAsStringSync();
  final updatedRoutesContent = routesFileContent.replaceFirst(
      '// Add other routes here',
      "static const String ${pageName.toUpperCase()} = '\$_prefix/${pageName}';\n  // Add other routes here");

  routesFile.writeAsStringSync(updatedRoutesContent);

  // Update navigation file
  final navigationFile = File(navigationFilePath);
  final navigationFileContent = navigationFile.readAsStringSync();
  final updatedNavigationContent = navigationFileContent.replaceFirst(';', """;\n
import 'bindings/${pageName}_controller_binding.dart';
import '../presentation/${pageName}/${pageName}_screen.dart';""").replaceFirst(
      '// Add other routes here',
      "GetPage(\n      name: ${_capitalize(featureName)}Routes.${pageName.toUpperCase()},\n      page: () => ${_capitalize(pageName)}Screen(),\n      binding: ${_capitalize(pageName)}ControllerBinding(),\n    ),\n    // Add other routes here");
  navigationFile.writeAsStringSync(updatedNavigationContent);

  print('Page "$pageName" created successfully within feature "$featureName".');
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String _pageTemplate(String pageName) {
  return '''
import 'package:flutter/material.dart';
import 'controllers/${pageName}_controller.dart';
import 'package:get/get.dart';

class ${_capitalize(pageName)}Screen extends GetView<${_capitalize(pageName)}ControllerController> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${_capitalize(pageName)} Screen'),
      ),
      body: Center(
        child: Text('Welcome to ${_capitalize(pageName)} Screen'),
      ),
    );
  }
}
''';
}

String _controllerTemplate(String pageName) {
  return '''
import 'package:get/get.dart';

class ${_capitalize(pageName)}Controller extends GetxController {
  // Controller logic
}
''';
}

String _bindingTemplate(String pageName) {
  return '''
import 'package:get/get.dart';
import '../../presentation/enrollement/controllers/${pageName}_controller.dart';

class ${_capitalize(pageName)}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${_capitalize(pageName)}Controller>(() => ${_capitalize(pageName)}Controller());
  }
}
''';
}

String _routesTemplate(String featureName) {
  return '''
class ${_capitalize(featureName)}Routes {
  static const String HOME = '/${featureName}';
  // Add other routes here
}
''';
}

String _navigationTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../presentation/views/${featureName}_screen.dart';
import '${featureName}_routes.dart';

class ${_capitalize(featureName)}Nav {
  static List<GetPage> routes = [
    GetPage(
      name: ${_capitalize(featureName)}Routes.HOME,
      page: () => ${_capitalize(featureName)}Screen(),
    ),
    // Add other routes here
  ];
}
''';
}

String _injectionTemplate(String featureName) {
  return '''
import 'package:get/get.dart';
import '../../presentation/enrollement/presentation/controllers/${featureName}_controller.dart';

class ${_capitalize(featureName)}DependenciesInjection {
  static void init() {
    Get.lazyPut<${_capitalize(featureName)}Controller>(() => ${_capitalize(featureName)}Controller());
    // Add other dependencies here
  }
}
''';
}

String _testTemplate(String featureName) {
  return '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('${_capitalize(featureName)} Tests', () {
    test('Initial Test', () {
      // Write your test here
    });
  });
}
''';
}
