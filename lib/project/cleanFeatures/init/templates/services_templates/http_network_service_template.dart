String httpNetworkServiceTemplate() {
  return '''
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:speedara_driver/core/exceptions/base_exception.dart';
import '../../utils/app_constants.dart';
import 'network_service.dart';

class HttpNetworkService extends NetworkService {
  var _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<dynamic> post(String url,
      {Map<String, String>? headers, dynamic body, Map<String, File>? files}) async {
    if (files != null && files.isNotEmpty) {
      return await _postMultipart(url, headers: headers, body: body, files: files);
    } else {
      final request = http.Request('POST', Uri.parse(AppConstants.baseUrl + url));
      request.body = json.encode(body);
      _headers = _headers..addAll(headers ?? {});
      request.headers.addAll(_headers);
      final response = await request.send();
      return _processResponse(response);
    }
  }

  Future<dynamic> _postMultipart(String url,
      {Map<String, String>? headers, dynamic body, required Map<String, File> files}) async {
    final request = http.MultipartRequest('POST', Uri.parse(AppConstants.baseUrl + url));
    _headers = _headers..addAll(headers ?? {});
    request.headers.addAll(_headers);

    // Add body fields if any
    if (body != null) {
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });
    }

    // Add files
    files.forEach((key, file) async {
      request.files.add(await http.MultipartFile.fromPath(key, file.path));
    });

    final response = await request.send();
    return _processResponse(response);
  }

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final request = http.Request('GET', Uri.parse(AppConstants.baseUrl + url));
    _headers = _headers..addAll(headers ?? {});
    request.headers.addAll(_headers);
    final response = await request.send();
    return _processResponse(response);
  }

  @override
  Future<dynamic> put(String url,
      {Map<String, String>? headers, dynamic body, Map<String, File>? files}) async {
    if (files != null && files.isNotEmpty) {
      return await _putMultipart(url, headers: headers, body: body, files: files);
    } else {
      final request = http.Request('PUT', Uri.parse(AppConstants.baseUrl + url));
      _headers = _headers..addAll(headers ?? {});
      request.headers.addAll(_headers);
      final response = await request.send();
      return _processResponse(response);
    }
  }

  Future<dynamic> _putMultipart(String url,
      {Map<String, String>? headers, dynamic body, required Map<String, File> files}) async {
    final request = http.MultipartRequest('PUT', Uri.parse(AppConstants.baseUrl + url));
    _headers = _headers..addAll(headers ?? {});
    request.headers.addAll(_headers);

    // Add body fields if any
    if (body != null) {
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });
    }

    // Add files
    files.forEach((key, file) async {
      request.files.add(await http.MultipartFile.fromPath(key, file.path));
    });

    final response = await request.send();
    return _processResponse(response);
  }

  @override
  Future<dynamic> delete(String url,
      {Map<String, String>? headers, dynamic body}) async {
    final request =
        http.Request('DELETE', Uri.parse(AppConstants.baseUrl + url));
    _headers = _headers..addAll(headers ?? {});
    request.headers.addAll(_headers);
    final response = await request.send();
    return _processResponse(response);
  }

  @override
  Future<dynamic> patch(String url,
      {Map<String, String>? headers, dynamic body}) async {
    final request =
        http.Request('PATCH', Uri.parse(AppConstants.baseUrl + url));
    _headers = _headers..addAll(headers ?? {});
    request.headers.addAll(_headers);
    final response = await request.send();
    return _processResponse(response);
  }

  Future<dynamic> _processResponse(http.StreamedResponse response) async {
    final body = jsonDecode(await response.stream.bytesToString());
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      throw BaseException(body["message"] ?? "Server error : \$statusCode");
    }
    return body;
  }
}

''';
}
