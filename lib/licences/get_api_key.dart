import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/licences/licence.dart';

Future<bool> getExpirationDate() async {
  stdout.write('${green}Please enter new licence to continue: $yellow');
  final apiKey = stdin.readLineSync()?.trim();
  try {
    final url = 'https://cv-pro.nosilab.net/api/key/$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final expirationDate = DateTime.parse(data['date_expiration']);
      final expirationDateString = expirationDate.toIso8601String();
      final encodedDate = encryptString(expirationDateString);
      await saveLicenceFile(encodedDate);
      print('${green}Licence saved successfully!$reset');
      return isLicenseValid();
    } else {
      print('${red}Failed to load expiration date. Status code: ${response.statusCode}$reset');
      return false;
    }
  } catch (e) {
    print('${red}Error occurred. Please check your internet connection or your licence key:$yellow \n----------\n$reset');
    return false;
  }
}
