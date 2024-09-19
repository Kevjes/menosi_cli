import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';

void generateModel(
    Map<String, dynamic> jsonResponse, String endpointName, String path) {
  final modelName = '${capitalize(endpointName)}Model';
  final entityName = capitalize(endpointName);
  final modelPath =
      '$path/infrastructure/models/${convertToSnakeCase(modelName)}.dart';

  final buffer = StringBuffer()
    ..writeln('//Don\'t translate me')
    ..writeln(
        "import '../../domain/entities/${convertToSnakeCase(entityName)}.dart';\n");

  void processModel(String name, Map<String, dynamic> json) {
    final modelClassName = '${capitalize(name)}Model';
    final entityClassName = capitalize(name);

    // Start the class definition
    buffer
      ..writeln('class $modelClassName {')
      ..writeln();

    // Add final variables
    json.forEach((key, value) {
      String type = "";
      if (value is Map) {
        type = "${capitalize(key)}Model";
      } else if (value is List) {
        type = 'List<${capitalize(key)}Model>';
      } else {
        type = getType(value);
      }
      buffer.writeln('  final $type ${transformToLowerCamelCase(key)};');
    });

    // Private constructor
    buffer
      ..writeln()
      ..writeln('  $modelClassName._({')
      ..writeln(json.keys.map((key) {
        return '    required this.${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  });')
      ..writeln();

    // fromJson method
    buffer
      ..writeln('  factory $modelClassName.fromJson(Map<String, dynamic> json) {')
      ..writeln('    return $modelClassName._(')
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
      ..writeln();

    // fromEntity method
    buffer
      ..writeln('  factory $modelClassName.fromEntity($entityClassName entity) {')
      ..writeln('    return $modelClassName._(')
      ..writeln(json.keys.map((key) {
        if (json[key] is Map) {
          return '      ${transformToLowerCamelCase(key)}: ${capitalize(key)}Model.fromEntity(entity.${transformToLowerCamelCase(key)}),';
        } else if (json[key] is List) {
          return '      ${transformToLowerCamelCase(key)}: List<${capitalize(key)}Model>.from(entity.${transformToLowerCamelCase(key)}.map((x) => ${capitalize(key)}Model.fromEntity(x))),';
        } else {
          return '      ${transformToLowerCamelCase(key)}: entity.${transformToLowerCamelCase(key)},';
        }
      }).join('\n'))
      ..writeln('    );')
      ..writeln('  }')
      ..writeln();

    // toJson method
    buffer
      ..writeln('  Map<String, dynamic> toJson() {')
      ..writeln('    final Map<String, dynamic> data = <String, dynamic>{};')
      ..writeln(json.keys.map((key) {
        if (json[key] is Map) {
          return '    data[\'$key\'] = ${transformToLowerCamelCase(key)}.toJson();';
        } else if (json[key] is List) {
          return '    data[\'$key\'] = ${transformToLowerCamelCase(key)}.map((x) => x.toJson()).toList();';
        } else {
          return '    data[\'$key\'] = ${transformToLowerCamelCase(key)};';
        }
      }).join('\n'))
      ..writeln('    return data;')
      ..writeln('  }')
      ..writeln();

    // toEntity method
    buffer
      ..writeln('  $entityClassName toEntity() {')
      ..writeln('    return $entityClassName.create(')
      ..writeln(json.keys.map((key) {
        if (json[key] is Map) {
          return '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}.toEntity(),';
        } else if (json[key] is List) {
          return '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}.map((x) => x.toEntity()).toList(),';
        } else {
          return '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
        }
      }).join('\n'))
      ..writeln('    );')
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
