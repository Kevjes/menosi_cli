import 'dart:io';
import 'dart:convert';

import 'package:menosi_cli/app/constants.dart';

void createEndpointCommandFile(
    String featureName, String endPointName, String commandFilePath) {
  final Map<String, dynamic> commandJson = {};

  print(
      '${green}Please enter the information to create the endpoint_command.json file');

  stdout.write('${green}HTTP Method ${yellow}(GET, POST, PUT, DELETE):$reset');
  commandJson['method'] = stdin.readLineSync()!.toUpperCase();

  stdout.write('${green}Endpoint path ${yellow}(e.g., /user/{userId}):$reset');
  commandJson['url'] = stdin.readLineSync()!;

  final Map<String, dynamic> parameters = {};

  stdout.write('${green}Are there any query parameters? ${yellow}(y/n):$reset');
  if (stdin.readLineSync()!.toLowerCase().contains('y')) {
    final Map<String, String> queryParams = {};
    String addMore;
    do {
      stdout.write('${green}Parameter name ${yellow}(e.g., search):$reset');
      String paramName = stdin.readLineSync()!;
      stdout
          .write('${green}Parameter type ${yellow}(string, int, etc.):$reset');
      String paramType = stdin.readLineSync()!;
      queryParams[paramName] = paramType;

      stdout
          .write('${green}Add another query parameter? ${yellow}(y/n):$reset');
      addMore = stdin.readLineSync()!;
    } while (addMore.toLowerCase().contains('y'));
    parameters['query'] = queryParams;
  }

  stdout.write('${green}Is there a request body? ${yellow}(y/n):$reset');
  if (stdin.readLineSync()!.toLowerCase().contains('y')) {
    final Map<String, dynamic> bodyParams = {};
    String addMore;
    do {
      stdout.write('${green}Field name ${yellow}(e.g., username):$reset');
      String fieldName = stdin.readLineSync()!;
      stdout.write('${green}Field type ${yellow}(string, int, double, bool, etc.):$reset');
      String fieldType = stdin.readLineSync()!;
      bodyParams[fieldName] = _getValue(fieldType);

      stdout.write(
          '${green}Add another field to the request body? ${yellow}(y/n):$reset');
      addMore = stdin.readLineSync()!;
    } while (addMore.toLowerCase().contains('y'));
    parameters['body'] = bodyParams;
  }

  commandJson['parameters'] = parameters;

  File(commandFilePath).createSync(recursive: true);
  File(commandFilePath).writeAsStringSync(jsonEncode(commandJson));
  print(
      '${green}The endpoint_command.json file has been successfully created at $commandFilePath$reset');
}

dynamic _getValue(String field) {
  return field.toLowerCase().contains('string')
      ? "String"
      : field.toLowerCase().contains('int')
          ? 12
          : field.toLowerCase().contains('double')
              ? 100.0
              : field.toLowerCase().contains('bool')
                  ? false
                  : null;
}
