import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import '../../app/functions.dart';

void generateEntity(
    Map<String, dynamic> jsonResponse, String entityName, String path, {bool includeFromJson = false}) {
  final entityPath = '$path/domain/entities/${convertToSnakeCase(entityName)}.dart';

  if (!fileExists(entityPath)) {
    final buffer = StringBuffer()
      ..writeln('class $entityName {')
      ..writeln();

    jsonResponse['data'].forEach((key, value) {
      if (value is Map) {
        final nestedEntityName = '${capitalize(key)}';
        buffer.writeln('  final $nestedEntityName ${transformToLowerCamelCase(key)};');
        generateEntity({'data': value}, nestedEntityName, path, includeFromJson: includeFromJson);
      } else if (value is List) {
        final nestedEntityName = '${capitalize(key)}';
        buffer.writeln('  final List<$nestedEntityName> ${transformToLowerCamelCase(key)};');
        if (value.isNotEmpty && value.first is Map) {
          generateEntity({'data': value.first}, nestedEntityName, path, includeFromJson: includeFromJson);
        }
      } else {
        buffer.writeln('  final ${getType(value)} ${transformToLowerCamelCase(key)};');
      }
    });

    buffer
      ..writeln()
      ..writeln('  const $entityName({')
      ..writeln(jsonResponse['data'].keys.map((key) {
        return '    required this.${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  });');

    if (includeFromJson) {
      buffer
        ..writeln()
        ..writeln('  factory $entityName.fromJson(Map<String, dynamic> json) {')
        ..writeln('    return $entityName(')
        ..writeln(jsonResponse['data'].keys.map((key) {
          if (jsonResponse['data'][key] is Map) {
            return '      ${transformToLowerCamelCase(key)}: ${capitalize(key)}.fromJson(json[\'$key\']),';
          } else if (jsonResponse['data'][key] is List) {
            return '      ${transformToLowerCamelCase(key)}: List<${capitalize(key)}>.from(json[\'$key\'].map((x) => ${capitalize(key)}.fromJson(x))),';
          } else {
            return '      ${transformToLowerCamelCase(key)}: json[\'$key\'],';
          }
        }).join('\n'))
        ..writeln('    );')
        ..writeln('  }');
    }

    buffer.writeln('}');

    File(entityPath).writeAsStringSync(buffer.toString());
    print('${green}$entityName generated at $entityPath${reset}');
  }
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
