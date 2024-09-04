import 'package:menosi_cli/app/functions.dart';

String mainCleanFeaturesTemplate(String projectPath) {
  return '''
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:$projectPath/core/navigation/routes/app_pages.dart';
import 'core/navigation/routes/app_routes.dart';
import 'core/dependences/app_dependences.dart';
import 'core/themes/app_themes.dart';

void main() async {
  await AppDependency.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(Main(AppRoutes.initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        initTheme: AppThemes.lightTheme,
        builder: (context, myTheme) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "${capitalize(projectPath)}",
            initialRoute: initialRoute,
            getPages: Get.find<AppPages>().getAllPages(),
            theme: myTheme,
            locale: const Locale('fr'), //Don't translate line
            translationsKeys: AppTranslation.translations
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

''';
}
