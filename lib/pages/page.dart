import 'dart:io';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

import 'pages_templates.dart';

void createPage(String featureName, String pageName) {
  final currentDir = Directory.current.path;
  featureName = transformToLowerCamelCase(featureName);
  pageName = transformToLowerCamelCase(pageName);
  final snakeFeatureName = convertToSnakeCase(featureName);
  final snakePageName = convertToSnakeCase(pageName);



  // Define the paths for the new page within the feature
  final pagePath = p.join(
      currentDir, 'lib', 'features', featureName, 'ui', pageName);
  final controllerPath = p.join(currentDir, 'lib', 'features', featureName,
      'ui', pageName, 'controllers');
  final bindingPath = p.join(
      currentDir, 'lib', 'features', featureName, 'navigation', 'bindings');
  final navigationFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', 'private', '${snakeFeatureName}_pages.dart');
  final routesFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', 'private', '${snakeFeatureName}_private_routes.dart');

  // Create the directory structure
  Directory(pagePath).createSync(recursive: true);
  Directory(controllerPath).createSync(recursive: true);
  Directory(bindingPath).createSync(recursive: true);

  // Create basic files with templates
  File(p.join(pagePath, '${snakePageName}_screen.dart'))
      .writeAsStringSync(pageTemplate(pageName));
  File(p.join(
          controllerPath, '${snakePageName}_controller.dart'))
      .writeAsStringSync(controllerTemplate(pageName));
  File(p.join(bindingPath,
          '${snakePageName}_controller_binding.dart'))
      .writeAsStringSync(bindingTemplate(pageName));

  // Update routes file
  final routesFile = File(routesFilePath);
  final routesFileContent = routesFile.readAsStringSync();
  final updatedRoutesContent = routesFileContent.replaceFirst(
      '}', "  static const String $pageName = '\$home/$pageName';\n}");

  routesFile.writeAsStringSync(updatedRoutesContent);

  // Update navigation file
  final navigationFile = File(navigationFilePath);
  final navigationFileContent = navigationFile.readAsStringSync();
  final updatedNavigationContent =
      navigationFileContent.replaceFirst(';', """;\n
import '../bindings/${snakePageName}_controller_binding.dart';
import '../../ui/$pageName/${snakePageName}_screen.dart';""").replaceFirst('// Add other routes here', "GetPage(\n      name: ${capitalize(featureName)}PrivateRoutes.${(pageName)},\n      page: () => ${capitalize(pageName)}Screen(),\n      binding: ${capitalize(pageName)}ControllerBinding(),\n    ),\n    // Add other routes here");
  navigationFile.writeAsStringSync(updatedNavigationContent);

  print('Page "$pageName" created successfully within feature "$featureName".');
}
