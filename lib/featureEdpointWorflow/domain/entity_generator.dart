import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../app/functions.dart';

void generateEntity(Map<String, dynamic> jsonResponse, String entityName, String path) {
  final entityPath = '$path/domain/entities/${convertToSnakeCase(entityName)}.dart';

  final buffer = StringBuffer();

  void processEntity(String name, Map<String, dynamic> json) {
    final entityClassName = capitalize(name);

    buffer
      ..writeln('class $entityClassName {')
      ..writeln();

    json.forEach((key, value) {
      if (value is Map) {
        final nestedEntityName = capitalize(key);
        buffer.writeln('  final $nestedEntityName ${transformToLowerCamelCase(key)};');
      } else if (value is List) {
        final nestedEntityName = capitalize(key);
        buffer.writeln('  final List<$nestedEntityName> ${transformToLowerCamelCase(key)};');
      } else {
        buffer.writeln('  final ${getType(value)} ${transformToLowerCamelCase(key)};');
      }
    });

    buffer
      ..writeln()
      ..writeln('  const $entityClassName._({')
      ..writeln(json.keys.map((key) {
        return '    required this.${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  });')
      ..writeln()
      ..writeln('  factory $entityClassName.create({')
      ..writeln(json.keys.map((key) {
        return '    required ${getType(json[key])} ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('  }) {')
      ..writeln('    // Add any validation or business logic here')
      ..writeln('    return $entityClassName._(')
      ..writeln(json.keys.map((key) {
        return '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
      }).join('\n'))
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();

    json.forEach((key, value) {
      if (value is Map) {
        processEntity(key, value as Map<String, dynamic>);
      } else if (value is List && value.isNotEmpty && value.first is Map) {
        processEntity(key, value.first); // Recursive call for list of nested entities
      }
    });
  }

  // Start processing the main entity
  processEntity(entityName, jsonResponse['data']);

  // Write the buffer to a single file
  File(entityPath).writeAsStringSync(buffer.toString());
  print('${green}$entityName and nested entities generated in $entityPath$reset');
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
