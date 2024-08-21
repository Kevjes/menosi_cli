import 'package:args/args.dart';
import 'package:menosi_cli/features/feature.dart';
import 'package:menosi_cli/pages/page.dart';

// Importez le script langify ici, supposant que vous l'avez placé dans lib/langify.dart
import 'package:menosi_cli/langify/langify.dart';

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

  final results = parser.parse(arguments);

  if (results.command?.name == 'create') {
    final featureName = results.command?['feature'] ?? 'feature';
    createFeature(featureName);
  } else if (results.command?.name == 'create_page') {
    final pageName = results.command?['name'] ?? 'page';
    final featureName = results.command?['feature'] ?? 'authentication';
    createPage(featureName, pageName);
  } else if (results.command?.name == 'langify') {
    mainLangifyCommand();
  } else {
    print('Usage: menosicli create --feature <feature_name>');
    print(
        'Usage: menosicli create_page --name <page_name> --feature <feature_name>');
    print('Usage: menosicli langify');
  }
}
