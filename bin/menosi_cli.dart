import 'dart:io';

import 'package:args/args.dart';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/project/cleanFeatures/featureEdpointWorflow/mainGenerateFeatureEndPointWorkflow.dart';
import 'package:menosi_cli/project/cleanFeatures/features/feature.dart';
import 'package:menosi_cli/langify/revert/langify_revert.dart';
import 'package:menosi_cli/langify/revert/revert.dart';
import 'package:menosi_cli/licences/licence.dart';
import 'package:menosi_cli/project/cleanFeatures/features/remove_feature.dart';
import 'package:menosi_cli/project/cleanFeatures/pages/page.dart';
import 'package:menosi_cli/langify/langify.dart';
import 'package:menosi_cli/project/cleanFeatures/init/init_project_clean_feature.dart';
import 'package:menosi_cli/project/cleanFeatures/pages/remove_page.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();

  // Sub-command for creating a feature
  parser.addCommand('create')
    ..addOption('feature', abbr: 'n', help: 'Name of the feature')
    ..addOption('page', abbr: 'p', help: 'Name of the page');
  // Sub-command for remove a feature
  parser.addCommand('remove')
    ..addOption('feature', abbr: 'n', help: 'Name of the feature')
    ..addOption('page', abbr: 'p', help: 'Name of the page');

  // Sub-command for langify
  parser.addCommand('langify')
    ..addFlag('revert',
        abbr: 'r', negatable: false, help: 'Revert the changes made by langify')
    ..addFlag('update',
        abbr: 'u',
        negatable: false,
        help: 'Update the translations in the files');
  // Sub-command for creating a feature
  parser.addCommand('generate')
    ..addOption('feature', abbr: 'f', help: 'Name of the feature')
    ..addOption('endpoint', abbr: 'e', help: 'Name of the endpoint')
    ..addOption('page', abbr: 'p', help: 'Name of the page');

  // Sub-command for init project
  parser.addCommand('init');

  final results = parser.parse(arguments);

  while (!(await isLicenseValid())) {
    print("${red}Invalid or expired license. Exiting...$reset");
    exit(1);
  }

  if (results.command?.name == 'create') {
    final featureName = results.command?['feature'];
    final pageName = results.command?['page'];
    if ((featureName == null && pageName == null) ||
        (pageName != null && featureName == null)) {
      print('${yellow}Usage: menosi create --feature <feature_name>');
      print(
          'Usage: menosi create --page <page_name> --feature <feature_name>${reset}');
      return;
    } else if (pageName != null && featureName != null) {
      createPage(featureName, pageName);
      return;
    }
    createFeature(featureName);
    return;
  } else if (results.command?.name == 'init') {
    stdout.write(
        '${red}Attention : Cette opération peut écraser vos fichiers existants. Êtes-vous sûr de vouloir continuer ? (oui/non): $yellow');
    final response = stdin.readLineSync()?.toLowerCase().trim();

    if (response == 'oui' || response == 'yes') {
      initProjectCleanFeatures();
      print('Projet initialisé avec succès.${reset}');
    } else {
      print('${red}Opération annulée.${reset}');
    }
    return;
  } else if (results.command?.name == 'langify') {
    final revert = results.command!['revert'] as bool;
    final update = results.command!['update'] as bool;
    if (update) {
      mainLangifyRevert();
      mainLangifyCommand();
      return;
    }
    if (revert) {
      return mainLangifyRevert();
    }
    if (loadTranslations('${Directory.current.path}/assets/locales/fr.json') !=
        null) {
      mainLangifyRevert();
      return mainLangifyCommand();
    } else {
      mainLangifyCommand();
    }
  } else if (results.command?.name == 'generate') {
    final featureName = results.command?['feature'];
    final endpoint = results.command?['endpoint'];
    if (featureName == null || endpoint == null) {
      print(
          '${red}Usage: menosi generate --feature <feature_name> --endpoint <endpoint_name> [--page <page_name>] ${reset}');
      return;
    }
    generateEndPointWorkflow(featureName, endpoint, results.command?['page']);
    return;
  } else if (results.command?.name == 'remove') {
    final featureName = results.command?['feature'];
    final pageName = results.command?['page'];
    if ((featureName == null && pageName == null) ||
        (pageName != null && featureName == null)) {
      print('${yellow}Usage: menosi remove --feature <feature_name>');
      print(
          'Usage: menosi remove --page <page_name> --feature <feature_name>${reset}');
      return;
    } else if (pageName != null && featureName != null) {
      removePage(featureName, pageName);
      return;
    }
    removeFeature(featureName);
    return;
  }else {
    print('${yellow}Usage: menosi init');
    print('Usage: menosi create --feature <feature_name>');
    print('Usage: menosi create --page <page_name> --feature <feature_name>');
    print('Usage: menosi langify');
    print('Usage: menosi langify [--revert]');
    print('Usage: menosi langify [--update');
    print(
        'Usage: menosi generate --feature <feature_name> --endpoint <endpoint_name> [--page <page_name>] ${reset}');
    print('Usage: menosi remove --feature <feature_name>');
    print('Usage: menosi remove --page <page_name> --feature <feature_name>');
  }
}
