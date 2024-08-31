import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

void updateEndpointDependeces(String dependencesPath, String endPointName) {
  final file = File(dependencesPath);
  if (file.existsSync()) {
    final content = file.readAsStringSync();
    final updateContent = content.replaceFirst("class", """
import '../application/usecases/${convertToSnakeCase(endPointName)}_usecase.dart';

class""").replaceFirst("}", """
    Get.lazyPut(() => ${capitalize(transformToLowerCamelCase(endPointName))}UseCase(Get.find()));
}""");

    file.writeAsStringSync(updateContent);
    print('${yellow}Dependences updated at $dependencesPath${reset}');
  } else {
    print('${red}Dependences file not found at $dependencesPath${reset}');
  }
}
