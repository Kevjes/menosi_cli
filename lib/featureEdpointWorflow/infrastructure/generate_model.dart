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

  final buffer = StringBuffer()
    ..writeln('//Don\'t translate me')
    ..writeln(
        "import '../../domain/entities/${convertToSnakeCase(endpointName)}.dart';\n");

  void processModel(String name, Map<String, dynamic> json) {
    final modelClassName = '${capitalize(name)}Model';
    final entityClassName = capitalize(name);

    buffer
      ..writeln('class $modelClassName extends $entityClassName {')
      ..writeln();

    buffer
      ..writeln()
      ..writeln('  const $modelClassName({')
      ..writeln(json.keys.map((key) {
        String type = "";
        if (json[key] is Map) {
          type = "${capitalize(key)}Model";
        } else if (json[key] is List) {
          type = 'List<${capitalize(key)}Model>';
        } else {
          type = getType(json[key]);
        }
        return '    required $type ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  }) : super(')
      ..writeln(json.keys.map((key) {
        return '          ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('        );')
      ..writeln()
      ..writeln(
          '  factory $modelClassName.fromJson(Map<String, dynamic> json) {')
      ..writeln('    return $modelClassName(')
      ..writeln(json.keys.map((key) {
        if (json[key] is Map) {
          return '      ${transformToLowerCamelCase(key)}: ${capitalize(key)}Model.fromJson(json[\'$key\']),';
        } else if (json[key] is List) {
          return '      ${transformToLowerCamelCase(key)}: List<${capitalize(key)}Model>.from(json[\'$key\'].map((x) => ${capitalize(key)}Model.fromJson(x))),';
        } else {
          return '      ${transformToLowerCamelCase(key)}: json[\'$key\'],';
        }
      }).join('\n'))
      ..writeln('    );')
      ..writeln('  }')
      ..writeln()
      ..writeln('  Map<String, dynamic> toJson() {')
      ..writeln('    return {')
      ..writeln(json.keys.map((key) {
        if (json[key] is Map) {
          return '      \'$key\': ${transformToLowerCamelCase(key)}.toJson(),';
        } else if (json[key] is List) {
          return '      \'$key\': List<dynamic>.from(${transformToLowerCamelCase(key)}.map((x) => x.toJson())),';
        } else {
          return '      \'$key\': ${transformToLowerCamelCase(key)},';
        }
      }).join('\n'))
      ..writeln('    };')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();

    // Recursively process nested models
    json.forEach((key, value) {
      if (value is Map) {
        processModel(key, value as Map<String, dynamic>);
      } else if (value is List && value.isNotEmpty && value.first is Map) {
        processModel(key, value.first);
      }
    });
  }

  // Start processing the main model
  processModel(endpointName, jsonResponse['data']);

  // Write the buffer to a single file
  File(modelPath).writeAsStringSync(buffer.toString());
  print('$green$modelName and nested models generated in $modelPath$reset');
}

String getType(dynamic jsonType) {
  if (jsonType is String) {
    return 'String';
  } else if (jsonType is int) {
    return 'int';
  } else if (jsonType is double) {
    return 'double';
  } else if (jsonType is bool) {
    return 'bool';
  } else {
    return 'dynamic';
  }
}
