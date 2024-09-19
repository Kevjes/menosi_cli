import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

void removePage(String featureName, String pageName) {
  final currentDir = Directory.current.path;
  featureName = transformToLowerCamelCase(featureName);
  pageName = transformToLowerCamelCase(pageName);
  final snakeFeatureName = convertToSnakeCase(featureName);
  final snakePageName = convertToSnakeCase(pageName);

  // Define the paths for the new page within the feature
  final pagePath =
      p.join(currentDir, 'lib', 'features', featureName, 'ui', pageName);
  final bindingPath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', 'bindings', '${snakePageName}_controller_binding.dart');
  final navigationFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', 'private', '${snakeFeatureName}_pages.dart');
  final routesFilePath = p.join(currentDir, 'lib', 'features', featureName,
      'navigation', 'private', '${snakeFeatureName}_private_routes.dart');

  // Verify if user want to remove the page
  print("${red}Are you sure you want to remove the $pageName page?");
  print("${red}This action cannot be undone.");
  print("${red}Are you sure you want to continue? y/n $reset");
  final answer = stdin.readLineSync();
  if (!(answer != null && answer.toLowerCase().startsWith('y'))) {
    print("${yellow}Page not removed.$reset");
    exit(0);
  }
  //remove folder page in ui
  if (Directory(pagePath).existsSync()) {
    Directory(pagePath).deleteSync(recursive: true);
    print("${yellow}Removed folder $pageName$reset");
  } else {
    print("${red}The folder $pageName doesn't exist.$reset");
  }

  //remove binding in navigation/bindings
  if (File(bindingPath).existsSync()) {
    File(bindingPath).deleteSync(recursive: true);
    print(
        "${yellow}Removed file ${snakePageName}_controller_binding.dart$reset");
  } else {
    print(
        "${red}The file ${snakePageName}_controller_binding.dart doesn't exist.$reset");
  }

  // Update routes file in navigation/private by removing the page
  if (File(routesFilePath).existsSync()) {
    final routesFile = File(routesFilePath);
    final routesFileContent = routesFile.readAsStringSync();
    routesFile.writeAsStringSync(
        removeLinesWithSearchWord(routesFileContent, pageName));
    print("${yellow}Updated ${snakeFeatureName}_private_routes.dart$reset");
  } else {
    print(
        "${red}The file ${snakeFeatureName}_private_routes.dart doesn't exist.$reset");
  }

  // Update navigation file in navigation/private by removing the page
  if (File(navigationFilePath).existsSync()) {
    final navigationFile = File(navigationFilePath);
    final navigationFileContent = navigationFile.readAsStringSync();
    final updatedNavigationContent = navigationFileContent
        .replaceAll(
            "import '../bindings/${snakePageName}_controller_binding.dart';\n",
            '')
        .replaceAll(
            "import '../../ui/$pageName/${snakePageName}_screen.dart';\n", '')
        .replaceAll(
            "GetPage(\n      name: ${capitalize(featureName)}PrivateRoutes.${(pageName)},\n      page: () => ${capitalize(pageName)}Screen(),\n      binding: ${capitalize(pageName)}ControllerBinding(),\n    ),\n",
            '\n');
    navigationFile.writeAsStringSync(updatedNavigationContent);
    print("${yellow}Updated ${snakeFeatureName}_pages.dart$reset");
  } else {
    print("${red}The file ${snakeFeatureName}_pages.dart doesn't exist.$reset");
  }

  print("${green}$pageName page removed successfully.$reset");
}

String removeLinesWithSearchWord(String fileContent, String searchWord) {
  List<String> lines = fileContent.split('\n');
  List<String> filteredLines =
      lines.where((line) => !line.contains(searchWord)).toList();
  return filteredLines.join('\n');
}
