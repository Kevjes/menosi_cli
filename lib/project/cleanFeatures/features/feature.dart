import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';
import 'package:menosi_cli/project/cleanFeatures/features/templates/constants_template.dart';
import 'package:menosi_cli/project/cleanFeatures/features/templates/exception_template.dart';
import 'package:menosi_cli/project/cleanFeatures/features/templates/feature_dependences_template.dart';
import 'package:menosi_cli/project/cleanFeatures/features/templates/repository_impl_template.dart';
import 'package:menosi_cli/project/cleanFeatures/features/updates/update_dependences.dart';
import 'package:menosi_cli/project/cleanFeatures/features/updates/update_global_routes.dart';
import 'package:menosi_cli/project/cleanFeatures/pages/pages_templates.dart';
import 'package:path/path.dart' as p;

import 'templates/feature_locale_storage.dart';
import 'templates/feature_storage_impl_template.dart';
import 'templates/features_templates.dart';
import 'templates/repository_template.dart';

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
  Directory(p.join(featurePath, 'application', 'usecases'))
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
  Directory(p.join(featurePath, 'domain', 'localStorage'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'infrastructure', 'models'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'infrastructure', 'repositoriesImpl'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'infrastructure', 'localStorageImpl'))
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
  print(
      '${green}created ${featurePath}/ui/${snakeFeatureName}_screen.dart${reset}');
  File(p.join(featurePath, 'ui', featureName, 'controllers',
          '${snakeFeatureName}_controller.dart'))
      .writeAsStringSync(controllerTemplate(featureName));
  print(
      '${green}created ${featurePath}/ui/${snakeFeatureName}_controller.dart${reset}');
  File(p.join(featurePath, 'navigation', 'bindings',
          '${snakeFeatureName}_controller_binding.dart'))
      .writeAsStringSync(bindingTemplate(featureName));
  print(
      '${green}created ${featurePath}/navigation/${snakeFeatureName}_controller_binding.dart${reset}');
  File(p.join(
          featurePath, 'navigation', '${snakeFeatureName}_public_routes.dart'))
      .writeAsStringSync(publicRoutesTemplate(featureName));
  print(
      '${green}created ${featurePath}/navigation/${snakeFeatureName}_public_routes.dart${reset}');
  File(p.join(featurePath, 'navigation', 'private',
          '${snakeFeatureName}_private_routes.dart'))
      .writeAsStringSync(privateRoutesTemplate(featureName));
  print(
      '${green}created ${featurePath}/navigation/${snakeFeatureName}_private_routes.dart${reset}');
  File(p.join(featurePath, 'navigation', 'private',
          '${snakeFeatureName}_pages.dart'))
      .writeAsStringSync(privatePagesTemplate(featureName));
  print(
      '${green}created ${featurePath}/navigation/${snakeFeatureName}_pages.dart${reset}');
  File(p.join(
          featurePath, 'dependences', '${snakeFeatureName}_dependencies.dart'))
      .writeAsStringSync(
          featureDependencesTemplate(featureName, snakeFeatureName));
  print(
      '${green}created ${featurePath}/dependences/${snakeFeatureName}_dependencies.dart${reset}');
  File(p.join(featurePath, 'domain', 'core', 'exceptions',
          '${snakeFeatureName}_exception.dart'))
      .writeAsStringSync(exceptionTemplate(featureName));
  print(
      '${green}created ${featurePath}/domain/core/exceptions/${snakeFeatureName}_exception.dart${reset}');
  File(p.join(featurePath, 'domain', 'core', 'utils',
          '${snakeFeatureName}_constants.dart'))
      .writeAsStringSync(constantsTemplate(featureName));
  print(
      '${green}created ${featurePath}/domain/core/utils/${snakeFeatureName}_constants.dart${reset}');
  File(p.join(featurePath, 'domain', 'repositories',
          '${snakeFeatureName}_repository.dart'))
      .writeAsStringSync(repositoryTemplate(featureName));
  print(
      '${green}created ${featurePath}/domain/repositories/${snakeFeatureName}_repository.dart${reset}');
  File(p.join(featurePath, 'domain', 'localStorage',
          '${snakeFeatureName}_local_storage.dart'))
      .writeAsStringSync(localStorageTemplate(featureName));
  print(
      '${green}created ${featurePath}/domain/localStorage/${snakeFeatureName}_local_storage.dart${reset}');
  File(p.join(featurePath, 'infrastructure', 'repositoriesImpl',
          '${snakeFeatureName}_repository_impl.dart'))
      .writeAsStringSync(repositoryImplTemplate(featureName));
  print(
      '${green}created ${featurePath}/infrastructure/repositoriesImpl/${snakeFeatureName}_repository_impl.dart${reset}');
  File(p.join(featurePath, 'infrastructure', 'localStorageImpl',
          '${snakeFeatureName}_local_storage_impl.dart'))
      .writeAsStringSync(localStorageImplTemplate(featureName));
  print(
      '${green}created ${featurePath}/infrastructure/localStorageImpl/${snakeFeatureName}_local_storage_impl.dart${reset}');

  // Create test file
  Directory(testFeaturePath).createSync(recursive: true);
  File(p.join(testFeaturePath, '${featureName}_test.dart'))
      .writeAsStringSync(testTemplate(featureName));
  print('${green}created ${testFeaturePath}/${featureName}_test.dart${reset}');

  // Update global dependencies injection file
  updateDependences(featureName, snakeFeatureName, injectionFilePath);
  print("${yellow}updated ${injectionFilePath}${reset}");

  // Update global Routes file
  updateGlobalRoutes(featureName, snakeFeatureName, appRoutesFilePath);
  print("${yellow}updated ${appRoutesFilePath}${reset}");

  print('${green}Feature "$featureName" created successfully.${reset}');
}
