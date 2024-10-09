import '../../../app/functions.dart';

void generateClassFields(Map<String, dynamic> json, StringBuffer buffer,
    {bool modelType = true}) {
  json.forEach((key, value) {
    String _k = key;
    if (key.startsWith('??')) {
      _k = key.substring(2);
    }
    buffer.writeln(
        '  final ${getType(key, value, modelType: modelType)} ${transformToLowerCamelCase(_k)};');
  });
}

void generateConstructor(
    Map<String, dynamic> json, String modelClassName, StringBuffer buffer) {
  buffer.writeln('  $modelClassName._({');
  generateConstructorParams(json, buffer);
  buffer.writeln('  });');
}

void generateConstructorParams(Map<String, dynamic> json, StringBuffer buffer) {
  buffer.writeln(json.keys.map((key) {
    bool isNullable = false;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String param = '    ';
    if (!isNullable) {
      param += 'required ';
    }
    param += 'this.${transformToLowerCamelCase(key)},';
    return param;
  }).join('\n'));
}

void generateSimpleParams(Map<String, dynamic> json, StringBuffer buffer) {
  json.forEach((key, value) {
    bool isNullable = false;
    if (key.startsWith('??')) {
      isNullable = true;
      key = key.substring(2);
    }
    String param = '    ';
    if (!isNullable) {
      param += 'required ';
    }
    param += '${transformToLowerCamelCase(key)},';
    buffer.writeln(param);
  });
}

String getType(String key, dynamic value, {bool modelType = true}) {
  String type = '';
  if (value is Map) {
    type =
        '${transformToUpperCamelCase(key.startsWith('??') ? key.substring(2) : key)}${modelType ? "Model" : ''}';
  } else if (value is List) {
    if (value.isNotEmpty) {
      var firstElement = value.first;
      if (firstElement is Map) {
        type =
            'List<${transformToUpperCamelCase(key.startsWith('??') ? key.substring(2) : key)}Model>';
      } else {
        type = 'List<${getNativeType(firstElement)}>';
      }
    } else {
      type = 'List<dynamic>';
    }
  } else {
    type = getNativeType(value);
  }

  if (key.startsWith('??')) {
    type += '?';
  }
  return type;
}

String getNativeType(dynamic value) {
  if (value == null) return 'dynamic';

  if (value is String) {
    return 'String';
  } else if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is bool) {
    return 'bool';
  } else {
    return 'dynamic';
  }
}

Map<String, String> analyseParametters(Map<String, dynamic> commandJson) {
  final parameters = <String, String>{};

  if (commandJson.containsKey('parameters')) {
    final params = commandJson['parameters'];
    if (params.containsKey('path')) {
      parameters.addAll(params['path'].map<String, String>((key, value) =>
          MapEntry<String, String>(
              (key as String).replaceAll("??", ''), getNativeType(value))));
    }
    if (params.containsKey('query')) {
      parameters.addAll(params['query'].map<String, String>((key, value) =>
          MapEntry<String, String>(
              (key as String).replaceAll("??", ''), getNativeType(value))));
    }
    if (params.containsKey('body')) {
      parameters.addAll(params['body'].map<String, String>((key, value) =>
          MapEntry<String, String>(
              (key as String).replaceAll("??", ''), getNativeType(value))));
    }
  }
  return parameters;
}
