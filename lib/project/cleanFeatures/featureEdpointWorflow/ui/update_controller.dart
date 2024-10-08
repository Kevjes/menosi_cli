import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';
import '../../../../langify/langify.dart';
import '../functions.dart';

void updateController(String controllerPath, String endpointName,
    Map<String, dynamic> commandJson) {
  final file = File(controllerPath);

  // Extraire les paramètres d'entrée depuis le JSON
  final parameters = analyseParametters(commandJson);

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
${!content.contains(extensionPath) ? extensionPath : ""}import '../../../application/usecases/${convertToSnakeCase(endpointName)}_usecase.dart';
${parameters.keys.isNotEmpty ? "import '../../../application/usecases/${convertToSnakeCase(endpointName)}_command.dart';" : ''}
class""").replaceFirst(");", """);
  final ${capitalize(useCaseVariableName)} _$useCaseVariableName = Get.find();
""");
  file.writeAsStringSync(updateContent);
  // Construct the method to be added
  final methodBuffer = StringBuffer()
    ..writeln('  Future<void> $methodName() async {')
    ..writeln('    Get.showLoader();')
    ..writeln(
        '    final result = await _$useCaseVariableName.call(${parameters.keys.isNotEmpty ? '${capitalize(endpointName)}Command(' : ''}')
    ..writeln(parameters.keys
        .map((key) =>
            '      ${transformToLowerCamelCase(key)} : ${transformToLowerCamelCase(key)}')
        .join(',\n'))
    ..writeln('    ${parameters.keys.isNotEmpty ? ')' : ''});')
    ..writeln('    result.fold(')
    ..writeln('      (e) {')
    ..writeln('         Get.closeLoader();')
    ..writeln('         Get.showCustomSnackBar(e.message);')
    ..writeln('      },')
    ..writeln('      (success) {')
    ..writeln('        Get.closeLoader();')
    ..writeln('        print(success);')
    ..writeln('        // Handle the success case')
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
