import '../../../app/functions.dart';

void generateConstructor(
    Map<String, dynamic> json, String modelClassName, StringBuffer buffer) {
  buffer.writeln('  $modelClassName._({');
  generateConstructorParams(json, buffer);
  buffer.writeln('  });');
}
void generateClassFields(Map<String, dynamic> json, StringBuffer buffer,
    {bool modelType = true, bool commandType =false}) {
  json.forEach((key, value) {
    String _k = key;
    if (key.startsWith('??')) {
      _k = key.substring(2);
    }
    buffer.writeln(
        '  final ${getType(key, value, modelType: modelType, commandType:commandType)} ${transformToLowerCamelCase(_k)};');
  });
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

String getType(String key, dynamic value, {bool modelType = true, bool commandType =false}) {
  String type = '';
  if (value is Map) {
    type =
        '${transformToUpperCamelCase(key.startsWith('??') ? key.substring(2) : key)}${modelType ? "Model" : ''}${commandType ? "Command" : ''}';
  } else if (value is List) {
    if (value.isNotEmpty) {
      var firstElement = value.first;
      if (firstElement is Map) {
        type =
            'List<${transformToUpperCamelCase(key.startsWith('??') ? key.substring(2) : key)}${modelType ? "Model" : ''}${commandType ? "Command" : ''}>';
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

    void collectParameters(Map<String, dynamic> paramMap) {
      paramMap.forEach((key, value) {
        String _k = key.startsWith('??') ? key.substring(2) : key;
        bool isNullable = key.startsWith('??');

        if (value is Map) {
          // Type personnalisé
          String typeName = transformToUpperCamelCase(_k) + 'Command';
          parameters[_k] = typeName + (isNullable ? '?' : '');
        } else if (value is List) {
          if (value.isNotEmpty && value.first is Map) {
            String typeName = 'List<${transformToUpperCamelCase(_k)}Command>';
            parameters[_k] = typeName + (isNullable ? '?' : '');
          } else {
            String itemType = value.isNotEmpty ? getNativeType(value.first) : 'dynamic';
            parameters[_k] = 'List<$itemType>' + (isNullable ? '?' : '');
          }
        } else {
          String type = getNativeType(value) + (isNullable ? '?' : '');
          parameters[_k] = type;
        }
      });
    }

    if (params.containsKey('path')) {
      collectParameters(params['path']);
    }
    if (params.containsKey('query')) {
      collectParameters(params['query']);
    }
    if (params.containsKey('body')) {
      collectParameters(params['body']);
    }
  }
  return parameters;
}


Map<String, dynamic> extractParameters(Map<String, dynamic> commandJson) {
  final parameters = <String, dynamic>{};

  if (commandJson.containsKey('parameters')) {
    final params = commandJson['parameters'];

    // Récupérer les paramètres de path
    if (params.containsKey('path')) {
      parameters.addAll(params['path']);
    }

    // Récupérer les paramètres de query
    if (params.containsKey('query')) {
      parameters.addAll(params['query']);
    }

    // Récupérer les paramètres de body
    if (params.containsKey('body')) {
      parameters.addAll(params['body']);
    }
  }
  return parameters;
}

