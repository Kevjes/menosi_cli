import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';

void addEndpointToFeatureConstants(String featureName, Map<String, dynamic> commandJson, String path, endpointConstantName) {
  final constantsPath = '$path/domain/core/utils/${convertToSnakeCase(featureName)}_constants.dart';
  final endpointUrl = commandJson['url'];

  if (fileExists(constantsPath)) {
    final file = File(constantsPath);
    final content = file.readAsStringSync();

    // Vérifier si la constante existe déjà
    if (!content.contains(endpointConstantName)) {
      final updatedContent = content.replaceFirst('}', '''
  static const String $endpointConstantName = '$endpointUrl';
}''');
      file.writeAsStringSync(updatedContent);
      print('${yellow}Endpoint added to feature constants at $constantsPath${reset}');
    } else {
      print('${yellow}Endpoint already exists in feature constants at $constantsPath${reset}');
    }
  } else {
    print('${red}Feature constants file not found at $constantsPath${reset}');
  }
}
