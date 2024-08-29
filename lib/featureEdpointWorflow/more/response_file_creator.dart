import 'dart:io';
import 'dart:convert';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

void createEndpointResponseFile(
    String featureName, String endPointName, String responseFilePath) {
  stdout.write('${yellow}Does this endpoint return a response? (y/n): $reset');
  String hasResponse = stdin.readLineSync()!.toLowerCase();

  Map<String, dynamic> responseJson;

  if (hasResponse.contains('y')) {
    print('${blue}Please paste the API JSON response:$reset');
    String jsonResponse = stdin.readLineSync()!;

    Map<String, dynamic> formattedResponse;
    try {
      formattedResponse = jsonDecode(jsonResponse);
    } catch (e) {
      print('${red}Error: The pasted response is not valid JSON.$reset');
      return;
    }

    responseJson = {'data': formattedResponse};
  } else {
    responseJson = {'data': {}};
    print(
        '${yellow}No response data provided; an empty response will be saved.$reset');
  }
  responseJson['responseName'] = convertToSnakeCase(endPointName);

  File(responseFilePath).createSync(recursive: true);
  File(responseFilePath).writeAsStringSync(jsonEncode(responseJson));
  print(
      '${green}The endpoint_response.json file has been successfully created at $responseFilePath$reset');
}
