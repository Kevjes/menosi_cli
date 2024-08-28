import 'package:menosi_cli/app/functions.dart';

String repositoryTemplate(String featureName) {
  return """
import 'package:dartz/dartz.dart';

abstract class ${capitalize(featureName)}Repository {
  //Add methods here
}

""";
}
