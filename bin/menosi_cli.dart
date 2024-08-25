import 'package:args/args.dart';
import 'package:menosi_cli/features/feature.dart';
import 'package:menosi_cli/pages/page.dart';

// Importez le script langify ici, supposant que vous l'avez placé dans lib/langify.dart
import 'package:menosi_cli/langify/langify.dart';
import 'package:menosi_cli/project/cleanFeatures/init_project_clean_feature.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // Sub-command for creating a feature
  parser.addCommand('create').addOption('feature',
      abbr: 'n', help: 'Name of the feature', defaultsTo: 'feature');

  // Sub-command for creating a page within a feature
  parser.addCommand('create_page')
    ..addOption('name', abbr: 'n', help: 'Name of the page', defaultsTo: 'page')
    ..addOption('feature',
        abbr: 'f',
        help: 'Name of the feature for the page',
        defaultsTo: 'authentication');

  // Sub-command for langify
  parser.addCommand('langify');

  // Sub-command for init project
  parser.addCommand('init');

  final results = parser.parse(arguments);

  if (results.command?.name == 'create') {
    final featureName = results.command?['feature'];
    if (featureName == null) {
      print('Usage: menosi create --feature <feature_name>');
      return;
    }
    createFeature(featureName);
  } else if (results.command?.name == 'init') {
    initProjectCleanFeatures();
  } else if (results.command?.name == 'create_page') {
    final pageName = results.command?['name'];
    final featureName = results.command?['feature'];
    if (pageName == null || featureName == null) {
      print(
          'Usage: menosi create_page --name <page_name> --feature <feature_name>');
      return;
    }
    createPage(featureName, pageName);
  } else if (results.command?.name == 'langify') {
    mainLangifyCommand();
  } else {
    print('Usage: menosi init');
    print('Usage: menosi create --feature <feature_name>');
    print(
        'Usage: menosi create_page --name <page_name> --feature <feature_name>');
    print('Usage: menosi langify');
  }
}
