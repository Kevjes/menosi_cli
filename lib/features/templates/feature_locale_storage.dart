import 'package:menosi_cli/app/functions.dart';

String localStorageTemplate(String featureName) {
  return """

abstract class ${capitalize(featureName)}LocalStorage {
  //Add methods here
}

""";
}
