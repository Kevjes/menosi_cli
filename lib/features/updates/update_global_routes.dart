import 'dart:io';

import 'package:menosi_cli/app/functions.dart';

void updateGlobalRoutes(
    String featureName, String snakeFeatureName, String appRoutesFilePath) {
  final appROuteFile = File(appRoutesFilePath);
  final updateAppRouteFileContent =
      appROuteFile.readAsStringSync().replaceFirst(";", """;
import '../../../features/$featureName/navigation/${snakeFeatureName}_public_routes.dart';
  """).replaceFirst("}", """
  //${capitalize(featureName)} Public Routes
  static const $featureName = ${capitalize(featureName)}PublicRoutes.home;
}""");
  appROuteFile.writeAsStringSync(updateAppRouteFileContent);
}
