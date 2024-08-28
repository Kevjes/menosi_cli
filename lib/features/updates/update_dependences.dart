import 'dart:io';

import 'package:menosi_cli/app/functions.dart';

void updateDependences(String featureName, String snakeFeatureName, String injectionFilePath) {
  final injectionFile = File(injectionFilePath);
  final injectionFileContent = injectionFile.readAsStringSync();
  final updatedContent = injectionFileContent
      .replaceFirst('class', """
import '../../features/$featureName/dependences/${snakeFeatureName}_dependencies.dart';
import '../../features/$featureName/navigation/private/${snakeFeatureName}_pages.dart';

class""")
      .replaceFirst('}', "    ${capitalize(featureName)}Dependencies.init();\n }")
      .replaceFirst("featuresPages = [", """featuresPages = [
      ${capitalize(featureName)}Pages(),""");
  injectionFile.writeAsStringSync(updatedContent);
}