import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import '../../../../app/functions.dart';
import '../functions.dart';

void generateModel(Map<String, dynamic> json, String name, String path) {
  StringBuffer buffer = StringBuffer();
  final model = "${transformToUpperCamelCase(name)}Model";
  final modelPath =
      '$path/infrastructure/models/${convertToSnakeCase(model)}.dart';
    buffer.writeln(
      "import '../../domain/entities/${convertToSnakeCase(name)}.dart';\n");
  processModel(name, json, buffer);
  // Write the buffer to a single file
  File(modelPath).writeAsStringSync(buffer.toString());
  print('$green$model and nested models generated in $modelPath$reset');
}

void processModel(String name, Map<String, dynamic> json, StringBuffer buffer) {
  final modelClassName = '${transformToUpperCamelCase(name)}Model';
  final entityClassName = transformToUpperCamelCase(name);

  buffer.writeln('class $modelClassName {');
  buffer.writeln();
  generateClassFields(json, buffer);
  buffer.writeln();
  generateConstructor(json, modelClassName, buffer);
  buffer.writeln();

  generateFromJson(json, modelClassName, buffer);
  buffer.writeln();

  generateToJson(json, buffer);
  buffer.writeln();

  generateFromEntity(json, modelClassName, entityClassName, buffer);
  buffer.writeln();

  generateToEntity(json, entityClassName, buffer);
  buffer.writeln('}');

  json.forEach((key, value) {
    if (key.startsWith('??')) {
      key = key.substring(2);
    }
    if (value is Map) {
      processModel(key, value as Map<String, dynamic>, buffer);
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      processModel(key, value.first, buffer);
    }
  });
}

void generateFromJson(
    Map<String, dynamic> json, String modelClassName, StringBuffer buffer) {
  buffer.writeln(
      '  factory $modelClassName.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $modelClassName._(');
  buffer.writeln(json.keys.map((key) {
    bool isNullable = false;
    String originalKey = key;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String assignment;
    var value = json[originalKey];

    if (value is Map) {
      if (isNullable) {
        assignment =
            '      ${transformToLowerCamelCase(key)}: json[\'$key\'] != null ? ${transformToUpperCamelCase(key)}Model.fromJson(json[\'$key\']) : null,';
      } else {
        assignment =
            '      ${transformToLowerCamelCase(key)}: ${transformToUpperCamelCase(key)}Model.fromJson(json[\'$key\']),';
      }
    } else if (value is List) {
      if (value.isNotEmpty) {
        var firstElement = value.first;
        if (firstElement is Map) {
          if (isNullable) {
            assignment =
                '      ${transformToLowerCamelCase(key)}: json[\'$key\'] != null ? List<${transformToUpperCamelCase(key)}Model>.from(json[\'$key\'].map((x) => ${transformToUpperCamelCase(key)}Model.fromJson(x))) : null,';
          } else {
            assignment =
                '      ${transformToLowerCamelCase(key)}: List<${transformToUpperCamelCase(key)}Model>.from(json[\'$key\'].map((x) => ${transformToUpperCamelCase(key)}Model.fromJson(x))),';
          }
        } else {
          String itemType = getType(originalKey, firstElement);
          if (isNullable) {
            assignment =
                '      ${transformToLowerCamelCase(key)}: json[\'$key\'] != null ? List<$itemType>.from(json[\'$key\']) : null,';
          } else {
            assignment =
                '      ${transformToLowerCamelCase(key)}: List<$itemType>.from(json[\'$key\']),';
          }
        }
      } else {
        if (isNullable) {
          assignment =
              '      ${transformToLowerCamelCase(key)}: json[\'$key\'] != null ? List<dynamic>.from(json[\'$key\']) : null,';
        } else {
          assignment =
              '      ${transformToLowerCamelCase(key)}: List<dynamic>.from(json[\'$key\']),';
        }
      }
    } else {
      assignment = '      ${transformToLowerCamelCase(key)}: json[\'$key\'],';
    }
    return assignment;
  }).join('\n'));
  buffer.writeln('    );');
  buffer.writeln('  }');
}

void generateToJson(Map<String, dynamic> json, StringBuffer buffer) {
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    final Map<String, dynamic> data = <String, dynamic>{};');
  buffer.writeln(json.keys.map((key) {
    bool isNullable = false;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String code;
    var value = json[key];

    if (value is Map) {
      if (isNullable) {
        code =
            '    if (${transformToLowerCamelCase(key)} != null) { data[\'$key\'] = ${transformToLowerCamelCase(key)}!.toJson(); }';
      } else {
        code =
            '    data[\'$key\'] = ${transformToLowerCamelCase(key)}.toJson();';
      }
    } else if (value is List) {
      if (value.isNotEmpty && value.first is Map) {
        if (isNullable) {
          code =
              '    if (${transformToLowerCamelCase(key)} != null) { data[\'$key\'] = ${transformToLowerCamelCase(key)}!.map((x) => x.toJson()).toList(); }';
        } else {
          code =
              '    data[\'$key\'] = ${transformToLowerCamelCase(key)}.map((x) => x.toJson()).toList();';
        }
      } else {
        if (isNullable) {
          code =
              '    if (${transformToLowerCamelCase(key)} != null) { data[\'$key\'] = ${transformToLowerCamelCase(key)}; }';
        } else {
          code = '    data[\'$key\'] = ${transformToLowerCamelCase(key)};';
        }
      }
    } else {
      if (isNullable) {
        code =
            '    if (${transformToLowerCamelCase(key)} != null) { data[\'$key\'] = ${transformToLowerCamelCase(key)}; }';
      } else {
        code = '    data[\'$key\'] = ${transformToLowerCamelCase(key)};';
      }
    }
    return code;
  }).join('\n'));
  buffer.writeln('    return data;');
  buffer.writeln('  }');
}

void generateFromEntity(Map<String, dynamic> json, String modelClassName,
    String entityClassName, StringBuffer buffer) {
  buffer.writeln(
      '  factory $modelClassName.fromEntity($entityClassName entity) {');
  buffer.writeln('    return $modelClassName._(');
  buffer.writeln(json.keys.map((key) {
    bool isNullable = false;
    String originalKey = key;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String assignment;
    var value = json[originalKey];

    if (value is Map) {
      if (isNullable) {
        assignment =
            '      ${transformToLowerCamelCase(key)}: entity.${transformToLowerCamelCase(key)} != null ? ${transformToUpperCamelCase(key)}Model.fromEntity(entity.${transformToLowerCamelCase(key)}!) : null,';
      } else {
        assignment =
            '      ${transformToLowerCamelCase(key)}: ${transformToUpperCamelCase(key)}Model.fromEntity(entity.${transformToLowerCamelCase(key)}),';
      }
    } else if (value is List) {
      if (value.isNotEmpty && value.first is Map) {
        if (isNullable) {
          assignment =
              '      ${transformToLowerCamelCase(key)}: entity.${transformToLowerCamelCase(key)} != null ? List<${transformToUpperCamelCase(key)}Model>.from(entity.${transformToLowerCamelCase(key)}!.map((x) => ${transformToUpperCamelCase(key)}Model.fromEntity(x))) : null,';
        } else {
          assignment =
              '      ${transformToLowerCamelCase(key)}: List<${transformToUpperCamelCase(key)}Model>.from(entity.${transformToLowerCamelCase(key)}.map((x) => ${transformToUpperCamelCase(key)}Model.fromEntity(x))),';
        }
      } else {
        assignment =
            '      ${transformToLowerCamelCase(key)}: entity.${transformToLowerCamelCase(key)},';
      }
    } else {
      assignment =
          '      ${transformToLowerCamelCase(key)}: entity.${transformToLowerCamelCase(key)},';
    }
    return assignment;
  }).join('\n'));
  buffer.writeln('    );');
  buffer.writeln('  }');
}

void generateToEntity(
    Map<String, dynamic> json, String entityClassName, StringBuffer buffer) {
  buffer.writeln('  $entityClassName toEntity() {');
  buffer.writeln('    return $entityClassName.create(');
  buffer.writeln(json.keys.map((key) {
    bool isNullable = false;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String assignment;
    var value = json[key];

    if (value is Map) {
      if (isNullable) {
        assignment =
            '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}?.toEntity(),';
      } else {
        assignment =
            '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}.toEntity(),';
      }
    } else if (value is List) {
      if (value.isNotEmpty && value.first is Map) {
        if (isNullable) {
          assignment =
              '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}?.map((x) => x.toEntity()).toList(),';
        } else {
          assignment =
              '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)}.map((x) => x.toEntity()).toList(),';
        }
      } else {
        assignment =
            '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
      }
    } else {
      assignment =
          '      ${transformToLowerCamelCase(key)}: ${transformToLowerCamelCase(key)},';
    }
    return assignment;
  }).join('\n'));
  buffer.writeln('    );');
  buffer.writeln('  }');
}
