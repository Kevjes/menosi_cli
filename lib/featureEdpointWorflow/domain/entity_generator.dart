import 'dart:io';

import 'package:menosi_cli/app/constants.dart';

import '../../app/functions.dart';

void generateEntity(
    Map<String, dynamic> jsonResponse, String entityName, String path) {
  final entityPath = '$path/domain/entities/${convertToSnakeCase(entityName)}.dart';

  if (!fileExists(entityPath)) {
    final buffer = StringBuffer()
      ..writeln('class $entityName {')
      ..writeln();

    jsonResponse['data'].forEach((key, value) {
      buffer.writeln('  final ${getType(value)} ${transformToUpperCamelCase(key)};');
    });

    buffer
      ..writeln()
      ..writeln('  const $entityName({')
      ..writeln(jsonResponse['data']
          .keys
          .map((key) => '    required this.${transformToUpperCamelCase(key)},')
          .join('\n'))
      ..writeln('  });')
      ..writeln()
      ..writeln('  factory $entityName.fromJson(Map<String, dynamic> json) {')
      ..writeln('    return $entityName(');

    jsonResponse['data'].forEach((key, _) {
      buffer.writeln('      ${transformToUpperCamelCase(key)}: json[\'$key\'],');
    });

    buffer
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}');

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
