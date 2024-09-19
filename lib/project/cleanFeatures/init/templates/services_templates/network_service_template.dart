String networkServiceTemplate() {
  return '''
abstract class NetworkService {
  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body});
  Future<dynamic> get(String url, {Map<String, String>? headers});
  Future<dynamic> put(String url, {Map<String, String>? headers, dynamic body});
  Future<dynamic> delete(String url, {Map<String, String>? headers, dynamic body});
  Future<dynamic> patch(String url, {Map<String, String>? headers, dynamic body});
}
''';
}
