import 'package:menosi_cli/app/functions.dart';

String constantsTemplate(String featureName) {
  return """
//Don't translate me
class ${capitalize(featureName)}Constants {

  static const String featureName = '${featureName}';
  static const String featureVersion = '1.0.0';

  // Add other constants here
}
""";
}
