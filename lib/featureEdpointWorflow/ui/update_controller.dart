import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

import '../../langify/langify.dart';
import '../domain/entity_generator.dart';

void updateController(String controllerPath, String endpointName,
    Map<String, dynamic> commandJson) {
  final file = File(controllerPath);

  // Extraire les paramètres d'entrée depuis le JSON
  final parameters = <String, String>{};

  if (commandJson.containsKey('parameters')) {
    final params = commandJson['parameters'];
    if (params.containsKey('query')) {
      parameters.addAll(params['query'].map<String, String>((key, value) =>
          MapEntry<String, String>(key as String, getType(value))));
    }
    if (params.containsKey('body')) {
      parameters.addAll(params['body'].map<String, String>((key, value) =>
          MapEntry<String, String>(key as String, getType(value))));
    }
  }

  if (!file.existsSync()) {
    print('${red}Controller file not found at $controllerPath$reset');
    return;
  }

  String content = file.readAsStringSync();
  final appName =
      getAppNameFromPubspec('${Directory.current.path}/pubspec.yaml');
  final methodName = transformToLowerCamelCase(endpointName);
  final useCaseVariableName =
      '${transformToLowerCamelCase("${endpointName}UseCase")}';
  final extensionPath =
      "import 'package:$appName/core/utils/getx_extensions.dart';\n";

  String updateContent = content.replaceFirst("class", """
${!content.contains(extensionPath)? extensionPath : ""}import '../../../application/useCases/${convertToSnakeCase(endpointName)}_usecase.dart';

class""").replaceFirst("{", """{
  final ${capitalize(useCaseVariableName)} _$useCaseVariableName;
""").replaceFirst("this._appNavigation", """this._appNavigation, this._$useCaseVariableName""");
  file.writeAsStringSync(updateContent);
  // Construct the method to be added
  final methodBuffer = StringBuffer()
    ..writeln('  Future<void> $methodName() async {')
    ..writeln('    Get.showLoader();')
    ..writeln('    final result = await _$useCaseVariableName.call(')
    ..writeln(parameters.keys
        .map((key) => '      ${transformToLowerCamelCase(key)}')
        .join(', '))
    ..writeln('    );')
    ..writeln('    result.fold(')
    ..writeln('      (e) {')
    ..writeln('         Get.closeLoader();')
    ..writeln('         Get.showCustomSnackBar(e.message);')
    ..writeln('      },')
    ..writeln('      (success) {')
    ..writeln('        // Handle the success case')
    ..writeln('        Get.closeLoader();')
    ..writeln('        print(success);')
    ..writeln('      },')
    ..writeln('    );')
    ..writeln('  }')
    ..writeln();

  // Insert the method before the last closing bracket
  final insertMethodPosition = updateContent.lastIndexOf('}');
  if (insertMethodPosition != -1) {
    updateContent = updateContent.substring(0, insertMethodPosition) +
        methodBuffer.toString() +
        updateContent.substring(insertMethodPosition);
    file.writeAsStringSync(updateContent);
    print(
        '${green}Method $methodName and dependencies added to $controllerPath$reset');
  } else {
    print(
        '${red}Error: Could not find insertion point in controller file$reset');
  }
}
