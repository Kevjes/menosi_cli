import 'dart:io';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

import 'features_templates.dart';

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
      .writeAsStringSync(pageTemplate(featureName));
  File(p.join(featurePath, 'presentation', 'controllers',
          '${featureName}_controller.dart'))
      .writeAsStringSync(controllerTemplate(featureName));
  File(p.join(featurePath, 'navigation', 'bindings',
          '${featureName}_controller_binding.dart'))
      .writeAsStringSync(bindingTemplate(featureName));
  File(p.join(featurePath, 'navigation', '${featureName}_routes.dart'))
      .writeAsStringSync(routesTemplate(featureName));
  File(p.join(featurePath, 'navigation', '${featureName}_navigation.dart'))
      .writeAsStringSync(navigationTemplate(featureName));
  File(p.join(featurePath, 'dependences',
          '${featureName}_dependencies_injection.dart'))
      .writeAsStringSync(injectionTemplate(featureName));

  // Create test file
  Directory(testFeaturePath).createSync(recursive: true);
  File(p.join(testFeaturePath, '${featureName}_test.dart'))
      .writeAsStringSync(testTemplate(featureName));

  // Update global dependencies injection file
  final injectionFile = File(injectionFilePath);
  final injectionFileContent = injectionFile.readAsStringSync();
  final updatedContent = injectionFileContent.replaceFirst(
      '}', "  ${capitalize(featureName)}DependenciesInjection.init();\n}");
  injectionFile.writeAsStringSync(updatedContent);

  print('Feature "$featureName" created successfully.');
}
