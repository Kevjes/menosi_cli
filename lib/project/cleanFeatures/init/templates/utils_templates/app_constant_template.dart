String appConstantTemplate() {
  return '''
//Don't translate me

class AppConstants{
  static const String appVersion = "1.0.0";
  static const String baseUrl = "https://www.myapi.com/";
  static const String notFoundScreen = "/404";
  static const String splashScreen = "/splash";
}
''';
}
