import 'dart:io';
import 'dart:convert';

import 'package:menosi_cli/app/constants.dart';

void createEndpointCommandFile(
    String featureName, String endPointName, String commandFilePath) {
  final Map<String, dynamic> commandJson = {};

  print(
      '${green}Please enter the information to create the endpoint_command.json file');

  stdout.write('${green}HTTP Method $yellow(GET, POST, PUT, DELETE):$reset');
  commandJson['method'] = stdin.readLineSync()!.toUpperCase();

  stdout.write('${green}Endpoint path $yellow(e.g., /auth/login):$reset');
  commandJson['url'] = stdin.readLineSync()!;

  final Map<String, dynamic> parameters = {};

  // Collecte des paramètres de requête
  stdout.write('${green}Are there any query parameters? $yellow(y/n):$reset');
  if (stdin.readLineSync()!.toLowerCase().contains('y')) {
    final Map<String, dynamic> queryParams = {};
    stdout.write(
        '${green}Enter parameter list name $yellow(e.g.:  userId, orderId, zoneId):$reset');
    String paramsName = stdin.readLineSync()!;
    paramsName.split(',').map((e) => queryParams[e.trim()] = e.trim()).toList();
    parameters['query'] = queryParams;
  }

  // Collecte du corps de la requête en JSON
  stdout.write('${green}Is there a request body? $yellow(y/n):$reset');
  if (stdin.readLineSync()!.toLowerCase().contains('y')) {
    print(
        '${blue}Please paste the request body JSON. Type "END" on a new line to finish:$reset');

    // Collecte du JSON multi-lignes
    StringBuffer jsonRequestBodyBuffer = StringBuffer();
    String? line;
    while ((line =
                stdin.readLineSync(encoding: Encoding.getByName('utf-8')!)) !=
            null &&
        line?.toUpperCase().trim() != 'END') {
      jsonRequestBodyBuffer.writeln(line?.trim());
    }

    String jsonRequestBody = jsonRequestBodyBuffer.toString().trim();

    try {
      // Nettoyage du JSON
      jsonRequestBody = jsonRequestBody.replaceAll(RegExp(r',\s*}'), '}');
      jsonRequestBody = jsonRequestBody.replaceAll(RegExp(r',\s*]'), ']');

      Map<String, dynamic> bodyParams = jsonDecode(jsonRequestBody);

      parameters['body'] = bodyParams;
    } catch (e) {
      print('${red}Error: The pasted request body is not valid JSON.$reset');
      print(e.toString());
      return;
    }
  }

  commandJson['parameters'] = parameters;

  File(commandFilePath).createSync(recursive: true);
  File(commandFilePath).writeAsStringSync(jsonEncode(commandJson));
  print(
      '${green}The endpoint_command.json file has been successfully created at $commandFilePath$reset');
}
