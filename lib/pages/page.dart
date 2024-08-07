import 'dart:io';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

import 'pages_templates.dart';

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
      .writeAsStringSync(pageTemplate(pageName));
  File(p.join(controllerPath, '${pageName}_controller.dart'))
      .writeAsStringSync(controllerTemplate(pageName));
  File(p.join(bindingPath, '${pageName}_controller_binding.dart'))
      .writeAsStringSync(bindingTemplate(pageName));

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
      "GetPage(\n      name: ${capitalize(featureName)}Routes.${pageName.toUpperCase()},\n      page: () => ${capitalize(pageName)}Screen(),\n      binding: ${capitalize(pageName)}ControllerBinding(),\n    ),\n    // Add other routes here");
  navigationFile.writeAsStringSync(updatedNavigationContent);

  print('Page "$pageName" created successfully within feature "$featureName".');
}
