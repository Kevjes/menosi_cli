import 'dart:developer';
import 'dart:io';
import 'package:menosi_cli/app/functions.dart';
import 'package:menosi_cli/pages/pages_templates.dart';
import 'package:path/path.dart' as p;

import 'features_templates.dart';

void createFeature(String featureName) {
  final currentDir = Directory.current.path;
  featureName = transformToLowerCamelCase(featureName);
  final snakeFeatureName = convertToSnakeCase(featureName);

  // Define the paths for the new feature
  final featurePath = p.join(currentDir, 'lib', 'features', (featureName));
  final testFeaturePath =
      p.join(currentDir, 'lib', 'features', featureName, 'tests');
  final injectionFilePath =
      p.join(currentDir, 'lib', 'core', 'dependences', 'app_dependences.dart');
  final appRoutesFilePath = p.join(
      currentDir, 'lib', 'core', 'navigation', 'routes', 'app_routes.dart');

  // Create the directory structure
  Directory(p.join(featurePath, 'application', 'useCases'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'application', 'validators'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'domain', 'core', 'exceptions'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'domain', 'core', 'utils'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'domain', 'entities'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'domain', 'repositories'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'infrastructure', 'models'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'infrastructure', 'repositoriesImpl'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'ui', featureName)).createSync(recursive: true);
  Directory(p.join(featurePath, 'ui', featureName, 'controllers'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'navigation', 'bindings'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'navigation', 'private'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'dependences')).createSync(recursive: true);
  Directory(p.join(featurePath, 'tests')).createSync(recursive: true);

  // Create basic files with templates
  File(p.join(
          featurePath, 'ui', featureName, '${snakeFeatureName}_screen.dart'))
      .writeAsStringSync(pageTemplate(featureName));
  File(p.join(featurePath, 'ui', featureName, 'controllers',
          '${snakeFeatureName}_controller.dart'))
      .writeAsStringSync(controllerTemplate(featureName));
  File(p.join(featurePath, 'navigation', 'bindings',
          '${snakeFeatureName}_controller_binding.dart'))
      .writeAsStringSync(bindingTemplate(featureName));
  File(p.join(
          featurePath, 'navigation', '${snakeFeatureName}_public_routes.dart'))
      .writeAsStringSync(publicRoutesTemplate(featureName));
  File(p.join(featurePath, 'navigation', 'private',
          '${snakeFeatureName}_private_routes.dart'))
      .writeAsStringSync(privateRoutesTemplate(featureName));
  File(p.join(featurePath, 'navigation', 'private',
          '${snakeFeatureName}_pages.dart'))
      .writeAsStringSync(privatePagesTemplate(featureName));
  File(p.join(
          featurePath, 'dependences', '${snakeFeatureName}_dependencies.dart'))
      .writeAsStringSync(injectionTemplate(featureName));
  File(p.join(featurePath, 'domain', 'core', 'exceptions',
          '${snakeFeatureName}_exception.dart'))
      .writeAsStringSync("""
import '../../../../../core/exceptions/base_exception.dart';

class ${capitalize(featureName)}Exception extends BaseException {
  ${capitalize(featureName)}Exception(String message) : super(message);
}""");

  // Create test file
  Directory(testFeaturePath).createSync(recursive: true);
  File(p.join(testFeaturePath, '${featureName}_test.dart'))
      .writeAsStringSync(testTemplate(featureName));

  // Update global dependencies injection file
  final injectionFile = File(injectionFilePath);
  final injectionFileContent = injectionFile.readAsStringSync();
  final updatedContent = injectionFileContent
      .replaceFirst('class', """
import '../../features/$featureName/dependences/${snakeFeatureName}_dependencies.dart';
import '../../features/$featureName/navigation/private/${snakeFeatureName}_pages.dart';

class""")
      .replaceFirst('}', "   ${capitalize(featureName)}Dependencies.init();\n}")
      .replaceFirst("featuresPages = [", """featuresPages = [
      ${capitalize(featureName)}Pages(),""");
  injectionFile.writeAsStringSync(updatedContent);

  // Update global Routes file
  final appROuteFile = File(appRoutesFilePath);
  final updateAppRouteFileContent =
      appROuteFile.readAsStringSync().replaceFirst(";", """;
import '../../../features/$featureName/navigation/${snakeFeatureName}_public_routes.dart';
  """).replaceFirst("}", """
  //${capitalize(featureName)} Public Routes
  static const $featureName = ${capitalize(featureName)}PublicRoutes.home;
}""");
  appROuteFile.writeAsStringSync(updateAppRouteFileContent);

  log('Feature "$featureName" created successfully.');
}
