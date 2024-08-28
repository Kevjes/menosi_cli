String httpNetworkServiceTemplate() {
  return '''
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_service.dart';
import '../../utils/app_constants.dart';

class HttpNetworkService extends NetworkService {
  @override
  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(
      Uri.parse(AppConstants.baseUrl + url),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse(AppConstants.baseUrl + url),
      headers: headers,
    );
    return _processResponse(response);
  }

  @override
  Future<dynamic> put(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(
      Uri.parse(AppConstants.baseUrl + url),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  @override
  Future<dynamic> delete(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.delete(
      Uri.parse(AppConstants.baseUrl + url),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  @override
  Future<dynamic> patch(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.patch(
      Uri.parse(AppConstants.baseUrl + url),
      headers: headers,
      body: json.encode(body),
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode < 200 || statusCode >= 400) {
      throw Exception("Une erreur est survenue");
    }

    return json.decode(body);
  }
}
''';
}
