import 'dart:io';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

import 'features_templates.dart';

void createFeature(String featureName) {
  final currentDir = Directory.current.path;

  // Define the paths for the new feature
  final featurePath = p.join(currentDir, 'lib', 'features', featureName);
  final testFeaturePath = p.join(currentDir, 'lib', 'features', featureName);
  final injectionFilePath = p.join(currentDir, 'lib', 'shares', 'dependences',
      'dependencies_injection.dart');
  final appNavigationFilePath =
      p.join(currentDir, 'lib', 'navigation', 'navigation.dart');
  final appRoutesFilePath =
      p.join(currentDir, 'lib', 'navigation', 'routes.dart');

  // Create the directory structure
  Directory(p.join(featurePath, 'presentation', featureName))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'presentation', featureName, 'controllers'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'navigation', 'bindings'))
      .createSync(recursive: true);
  Directory(p.join(featurePath, 'navigation')).createSync(recursive: true);
  Directory(p.join(featurePath, 'dependences')).createSync(recursive: true);
  Directory(p.join(featurePath, 'tests')).createSync(recursive: true);

  // Create basic files with templates
  File(p.join(featurePath, 'presentation', featureName,
          '${featureName}_screen.dart'))
      .writeAsStringSync(pageTemplate(featureName));
  File(p.join(featurePath, 'presentation', featureName, 'controllers',
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
  final updatedContent = injectionFileContent.replaceFirst('class', """
import '../../features/$featureName/dependences/${featureName}_dependencies_injection.dart';

class""").replaceFirst('}', "  ${capitalize(featureName)}DependenciesInjection.init();\n}");
  injectionFile.writeAsStringSync(updatedContent);

  // Update global Routes file
  final appROuteFile = File(appRoutesFilePath);
  final updateAppRouteFileContent =
      appROuteFile.readAsStringSync().replaceFirst(";", """;
  static const ${featureName.toUpperCase()} = '/$featureName';""");
  appROuteFile.writeAsStringSync(updateAppRouteFileContent);

  // Update global Navigation file
  final appNavigationFile = File(appNavigationFilePath);
  final updateAppNavigationFileContent =
      appNavigationFile.readAsStringSync().replaceAll("class", """
import '../features/$featureName/navigation/${featureName}_navigation.dart';

class""").replaceFirst("];", """

    //$featureName feature
    ...generateFeatureRoutes(
      baseRoute: Routes.${featureName.toUpperCase()},
      initialFeatureRoute: ${capitalize(featureName)}Navigation.initialRoute,
      featureRoutes: ${capitalize(featureName)}Navigation.routes,
    ),
  ];""");
  appNavigationFile.writeAsStringSync(updateAppNavigationFileContent);

  print('Feature "$featureName" created successfully.');
}
