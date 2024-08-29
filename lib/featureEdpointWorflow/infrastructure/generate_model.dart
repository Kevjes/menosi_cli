import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/featureEdpointWorflow/domain/entity_generator.dart';

import '../../app/functions.dart';

void generateModel(
    Map<String, dynamic> jsonResponse, String modelName, String path) {
  final modelPath =
      '$path/infrastructure/models/${convertToSnakeCase(modelName)}.dart';
  modelName = capitalize(modelName);

  if (!fileExists(modelPath)) {
    final buffer = StringBuffer()
      ..writeln('class $modelName {')
      ..writeln();

    jsonResponse['data'].forEach((key, value) {
      buffer.writeln(
          '  final ${getType(value)} ${transformToUpperCamelCase(key)};');
    });

    buffer
      ..writeln()
      ..writeln('  const $modelName({')
      ..writeln(jsonResponse['data']
          .keys
          .map((key) => '    required this.${transformToUpperCamelCase(key)},')
          .join('\n'))
      ..writeln('  });')
      ..writeln()
      ..writeln('  factory $modelName.fromJson(Map<String, dynamic> json) {')
      ..writeln('    return $modelName(');

    jsonResponse['data'].forEach((key, _) {
      buffer
          .writeln('      ${transformToUpperCamelCase(key)}: json[\'$key\'],');
    });

    buffer
      ..writeln('    );')
      ..writeln('  }')
      ..writeln()
      ..writeln('  Map<String, dynamic> toJson() {')
      ..writeln('    return {');

    jsonResponse['data'].forEach((key, _) {
      buffer.writeln('      \'$key\': ${transformToUpperCamelCase(key)},');
    });

    buffer
      ..writeln('    };')
      ..writeln('  }')
      ..writeln('}');

    File(modelPath).writeAsStringSync(buffer.toString());
    print('$green$modelName generated at $modelPath$reset');
  }
}
