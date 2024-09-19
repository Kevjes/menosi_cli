import 'dart:io';
import 'dart:convert';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';

void createEndpointResponseFile(
    String featureName, String endPointName, String responseFilePath) {
  stdout.write('${yellow}Does this endpoint return a response? (y/n): $reset');
  String hasResponse =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8')!)!.toLowerCase();
  print(hasResponse);

  Map<String, dynamic> responseJson;

  if (hasResponse.contains('y')) {
    print(
        '${blue}Please paste the API JSON response. Type "END" on a new line to finish:$reset');

    // Collecting multi-line JSON response
    StringBuffer jsonResponseBuffer = StringBuffer();
    String? line;
    while ((line =
                stdin.readLineSync(encoding: Encoding.getByName('utf-8')!)) !=
            null &&
        line?.trim() != 'END') {
      jsonResponseBuffer.writeln(line?.trim());
    }

    String jsonResponse = jsonResponseBuffer.toString().trim();

    try {
      // Clean up any potential trailing commas or other issues
      jsonResponse = jsonResponse.replaceAll(RegExp(r',\s*}'), '}');
      jsonResponse = jsonResponse.replaceAll(RegExp(r',\s*]'), ']');

      Map<String, dynamic> formattedResponse = jsonDecode(jsonResponse);

      // Check if the response already contains a 'data' key
      // if (formattedResponse.containsKey('data')) {
      //   responseJson = formattedResponse;
      // } else {
        responseJson = {'data': formattedResponse};
      // }
    } catch (e) {
      print('${red}Error: The pasted response is not valid JSON.$reset');
      print(e.toString());
      return;
    }
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
