import 'package:menosi_cli/app/functions.dart';

String repositoryTemplate(String featureName) {
  return """

abstract class ${capitalize(featureName)}LocalStorage {
  //Add methods here
}

""";
}
