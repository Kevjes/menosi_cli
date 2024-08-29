import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/featureEdpointWorflow/domain/entity_generator.dart';

import '../../app/functions.dart';

void generateModel(
    Map<String, dynamic> jsonResponse, String endpointName, String path) {
  final modelName = '${capitalize(endpointName)}Model';
  final entityName = capitalize(endpointName);
  final modelPath =
      '$path/infrastructure/models/${convertToSnakeCase(modelName)}.dart';

  if (!fileExists(modelPath)) {
    final buffer = StringBuffer()
      ..writeln('//Don\'t translate me')
      ..writeln(
          "import '../../domain/entities/${convertToSnakeCase(endpointName)}.dart';\n")
      ..writeln('class $modelName extends $entityName {')
      ..writeln();

    // jsonResponse['data'].forEach((key, value) {
    //   if (value is Map) {
    //     final nestedModelName = '${capitalize(key)}Model';
    //     buffer.writeln('  final $nestedModelName ${transformToLowerCamelCase(key)};');
    //     generateModel({'data': value}, key, path); // Générer le modèle imbriqué
    //   } else if (value is List) {
    //     final nestedModelName = '${capitalize(key)}Model';
    //     buffer.writeln('  final List<$nestedModelName> ${transformToLowerCamelCase(key)};');
    //     if (value.isNotEmpty && value.first is Map) {
    //       generateModel({'data': value.first}, key, path); // Générer le modèle de la liste
    //     }
    //   } else {
    //     buffer.writeln(
    //         '  final ${getType(value)} ${transformToLowerCamelCase(key)};');
    //   }
    // });

    buffer
      ..writeln()
      ..writeln('  const $modelName({')
      ..writeln(jsonResponse['data'].keys.map((key) {
        return '    required ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  }) : super(')
      ..writeln(jsonResponse['data'].keys.map((key) {
        return '          ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('        );')
      ..writeln()
      ..writeln('  factory $modelName.fromJson(Map<String, dynamic> json) {')
      ..writeln('    return $modelName(')
      ..writeln(jsonResponse['data'].keys.map((key) {
        if (jsonResponse['data'][key] is Map) {
          return '      ${transformToLowerCamelCase(key)}: ${capitalize(key)}Model.fromJson(json[\'$key\']),';
        } else if (jsonResponse['data'][key] is List) {
          return '      ${transformToLowerCamelCase(key)}: List<$capitalize(key)Model>.from(json[\'$key\'].map((x) => ${capitalize(key)}Model.fromJson(x))),';
        } else {
          return '      ${transformToLowerCamelCase(key)}: json[\'$key\'],';
        }
      }).join('\n'))
      ..writeln('    );')
      ..writeln('  }')
      ..writeln()
      ..writeln('  Map<String, dynamic> toJson() {')
      ..writeln('    return {')
      ..writeln(jsonResponse['data'].keys.map((key) {
        if (jsonResponse['data'][key] is Map) {
          return '      \'$key\': ${transformToLowerCamelCase(key)}.toJson(),';
        } else if (jsonResponse['data'][key] is List) {
          return '      \'$key\': List<dynamic>.from(${transformToLowerCamelCase(key)}.map((x) => x.toJson())),';
        } else {
          return '      \'$key\': ${transformToLowerCamelCase(key)},';
        }
      }).join('\n'))
      ..writeln('    };')
      ..writeln('  }')
      ..writeln('}');

    File(modelPath).writeAsStringSync(buffer.toString());
    print('$green$modelName generated at $modelPath$reset');
  } else {
    print('$yellow$modelName already exists at $modelPath$reset');
  }
}
