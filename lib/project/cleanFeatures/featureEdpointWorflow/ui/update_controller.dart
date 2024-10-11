import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

void updateController(String controllerPath, String endpointName,
    Map<String, dynamic> commandJson,
    {bool forForm = false, required String featureName}) {
  final file = File(controllerPath);

  if (!file.existsSync()) {
    print('${red}Controller file not found at $controllerPath$reset');
    return;
  }

  String content = file.readAsStringSync();
  final methodName = transformToLowerCamelCase(endpointName);
  final useCaseVariableName =
      transformToLowerCamelCase("${endpointName}UseCase");
  final extensionPath =
      "import '../../../../../core/utils/getx_extensions.dart';\n";

  // Préparer les imports
  String imports = """
${!content.contains(extensionPath) ? extensionPath : ""}
import '../../../application/usecases/${convertToSnakeCase(endpointName)}_usecase.dart';
import '../../../application/usecases/${convertToSnakeCase(endpointName)}_command.dart';
""";

  final v = "import '../../../../../core/services/form/validators.dart';\n";
  final f = "import '../../../../../core/services/form/form_helper.dart';\n";
  final e =
      "import '../../../domain/core/exceptions/${convertToSnakeCase(featureName)}_exception.dart';\n";
  final en =
      "import '../../../domain/entities/${convertToSnakeCase(endpointName)}.dart';\n";
  if (forForm) {
    imports += """
${!content.contains(v) ? v : ''}
${!content.contains(f) ? f : ''}
${!content.contains(e) ? e : ''}
${!content.contains(en) ? en : ''}
""";
  }

  // Mettre à jour le contenu du contrôleur avec les imports
  String updateContent = content.replaceFirst("class", imports + "class");

  // Préparer la déclaration des variables
  String variableDeclarations =
      "final ${capitalize(useCaseVariableName)} _$useCaseVariableName = Get.find();";
  if (forForm) {
    variableDeclarations += "\n  late FormHelper ${methodName}FormHelper;";
  }

  // Insérer les déclarations de variables après le constructeur
  int classStartIndex = updateContent.indexOf('class');
  int classBodyStartIndex = updateContent.indexOf('{', classStartIndex);
  updateContent = updateContent.substring(0, classBodyStartIndex + 1) +
      '\n  ' +
      variableDeclarations +
      '\n' +
      updateContent.substring(classBodyStartIndex + 1);

  // Extraire les paramètres
  Map<String, dynamic> parameters = extractParameters(commandJson);

  if (forForm) {
    // Collecter les champs et les validateurs
    Map<String, bool> fields = {};
    collectFields(parameters, fields);

    // Générer le code des champs
    String fieldsCode = fields.keys
        .map((fieldName) => '        "$fieldName": null,')
        .join('\n');

    // Générer le code des validateurs
    String validatorsCode = fields.entries
        .where((entry) => !entry.value) // Champs non nullables
        .map((entry) => '        "${entry.key}": Validators.requiredField,')
        .join('\n');

    // Générer le code onSubmit
    String onSubmitCode = generateOnSubmitCommand(
        parameters, '${capitalize(endpointName)}Command', 'data');

    // Générer le code d'initialisation de formHelper
    String formHelperInit = '''
    ${methodName}FormHelper = FormHelper<${capitalize(featureName)}Exception, ${capitalize(endpointName)}>(
      fields: {
$fieldsCode
      },
      validators: {
$validatorsCode
      },
      onSubmit: (data) => _${transformToLowerCamelCase(endpointName)}UseCase.call(
$onSubmitCode
      ),
      onError: (e) => Get.showCustomSnackBar(e.message),
      onSuccess: (response) {
        print(response);
      },
    );
''';

    // Injecter formHelperInit dans onInit()
    if (updateContent.contains('void onInit()')) {
      // onInit() existe
      int onInitIndex = updateContent.indexOf('void onInit()');
      int superOnInitIndex =
          updateContent.indexOf('super.onInit();', onInitIndex);
      int insertIndex = updateContent.indexOf('\n', superOnInitIndex);
      updateContent = updateContent.substring(0, insertIndex + 1) +
          formHelperInit +
          updateContent.substring(insertIndex + 1);
    } else {
      // onInit() n'existe pas, le créer
      int classEndIndex = updateContent.lastIndexOf('}');
      updateContent = updateContent.substring(0, classEndIndex) +
          '''
  @override
  void onInit() {
    super.onInit();
$formHelperInit
  }
''' +
          updateContent.substring(classEndIndex);
    }

    // Supprimer la méthode register() si elle existe
    final methodStart = updateContent.indexOf('Future<void> $methodName()');
    if (methodStart != -1) {
      int methodEnd = updateContent.indexOf('}', methodStart) + 1;
      updateContent = updateContent.substring(0, methodStart) +
          updateContent.substring(methodEnd);
    }
  } else {
    // forForm est false, générer la méthode comme avant
    // Générer le code des paramètres de la méthode
    String methodParameters = generateMethodParameters(parameters);

    // Construire la méthode à ajouter
    final methodBuffer = StringBuffer()
      ..writeln('  Future<void> $methodName() async {')
      ..writeln('    Get.showLoader();')
      ..writeln('    final result = await _$useCaseVariableName.call(')
      ..writeln('      ${capitalize(endpointName)}Command$methodParameters')
      ..writeln('    );')
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

    // Insérer la méthode avant la dernière accolade fermante
    final insertMethodPosition = updateContent.lastIndexOf('}');
    if (insertMethodPosition != -1) {
      updateContent = updateContent.substring(0, insertMethodPosition) +
          methodBuffer.toString() +
          updateContent.substring(insertMethodPosition);
    } else {
      print(
          '${red}Error: Could not find insertion point in controller file$reset');
      return;
    }
  }

  // Écrire le contenu mis à jour dans le fichier
  file.writeAsStringSync(updateContent);
  print('${green}Controller updated at $controllerPath$reset');
}

// Fonction pour extraire les paramètres
Map<String, dynamic> extractParameters(Map<String, dynamic> commandJson) {
  Map<String, dynamic> parameters = {};
  if (commandJson.containsKey('parameters')) {
    final params = commandJson['parameters'];
    if (params.containsKey('query')) {
      parameters.addAll(params['query']);
    }
    if (params.containsKey('body')) {
      parameters.addAll(params['body']);
    }
    if (params.containsKey('path')) {
      parameters.addAll(params['path']);
    }
  }
  return parameters;
}

// Fonction pour collecter les champs et leur nullabilité
void collectFields(Map<String, dynamic> parameters, Map<String, bool> fields) {
  parameters.forEach((key, value) {
    bool isNullable = key.startsWith('??');
    String fieldName =
        transformToLowerCamelCase(isNullable ? key.substring(2) : key);
    if (value is Map<String, dynamic>) {
      collectFields(value, fields);
    } else {
      fields[fieldName] = isNullable;
    }
  });
}

// Fonction pour générer le code onSubmit
String generateOnSubmitCommand(
    Map<String, dynamic> parameters, String commandName, String dataVariable, 
    {bool itSdouble = true}) {
  StringBuffer buffer = StringBuffer();
  if(itSdouble) {
    buffer.writeln('        $commandName(');
  }
  parameters.forEach((key, value) {
    bool isNullable = key.startsWith('??');
    String fieldName =
        transformToLowerCamelCase(isNullable ? key.substring(2) : key);

    if (value is Map<String, dynamic>) {
      String nestedCommandName =
          '${transformToUpperCamelCase(fieldName)}Command';
      String nestedOnSubmit =
          generateOnSubmitCommand(value, nestedCommandName, dataVariable, itSdouble: false);
      buffer.writeln('          $fieldName: $nestedCommandName(');
      buffer.writeln("  $nestedOnSubmit");
      buffer.writeln('          ),');
    } else {
      buffer.writeln(
          '          $fieldName: $dataVariable[\'$fieldName\']${isNullable ? '' : '!'},');
    }
  });
  if(itSdouble) {
    buffer.writeln('        )');
  }

  return buffer.toString();
}

// Fonction pour générer les paramètres de la méthode
String generateMethodParameters(Map<String, dynamic> parameters) {
  StringBuffer buffer = StringBuffer();
  buffer.writeln('(');
  List<String> params = [];
  parameters.forEach((key, value) {
    params.add("        ${generateParameterValue(key, value)}");
  });
  buffer.writeln(params.join(',\n'));
  buffer.writeln('      )');
  return buffer.toString();
}

String generateParameterValue(String key, dynamic value) {
  String _key = key.startsWith('??') ? key.substring(2) : key;
  if (value is Map<String, dynamic>) {
    String className = '${transformToUpperCamelCase(_key)}Command';
    String nestedParams = value.keys
        .map((k) => generateParameterValue(k, value[k]))
        .join(',\n         ');
    return '${transformToLowerCamelCase(_key)}: $className(\n         $nestedParams\n        )';
  } else if (value is List) {
    return '${transformToLowerCamelCase(_key)}: ${transformToLowerCamelCase(_key)}';
  } else {
    return '${transformToLowerCamelCase(_key)}: ${transformToLowerCamelCase(_key)}';
  }
}
