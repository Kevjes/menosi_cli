import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void generateEntity(
    Map<String, dynamic> jsonResponse, String entityName, String path) {
  final entityPath =
      '$path/domain/entities/${convertToSnakeCase(entityName)}.dart';
  final buffer = StringBuffer();
  processEntity(entityName, jsonResponse, buffer);
  File(entityPath).writeAsStringSync(buffer.toString());
  print(
      '$green$entityName and nested entities generated in $entityPath$reset');
}

void processEntity(
    String name, Map<String, dynamic> json, StringBuffer buffer) {
  final entityClassName = transformToUpperCamelCase(name);

  buffer.writeln('class $entityClassName {');
  buffer.writeln();

  generateClassFields(json, buffer, modelType: false);
  buffer.writeln();

  generateConstructor(json, entityClassName, buffer);
  buffer.writeln();

  generateFactoryCreate(json, entityClassName, buffer);
  buffer.writeln();
  buffer.writeln('}');

  json.forEach((key, value) {
    if (key.startsWith('??')) {
      key = key.substring(2);
    }
    if (value is Map) {
      processEntity(key, value as Map<String, dynamic>, buffer);
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      processEntity(key, value.first, buffer);
    }
  });
}

void generateFactoryCreate(
    Map<String, dynamic> json, String entityClassName, StringBuffer buffer) {
  buffer.writeln('  factory $entityClassName.create({');
  generateSimpleParams(json, buffer);
  buffer.writeln('  }) {');
  buffer.writeln('    // Add any validation or business logic here');
  buffer.writeln('    return $entityClassName._(');
  buffer.writeln(json.keys.map((key) {
    if (key.startsWith('??')) {
      key = key.substring(2);
    }
    return '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
  }).join('\n'));
  buffer.writeln('    );');
  buffer.writeln('  }');
}
