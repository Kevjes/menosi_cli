String mainCleanFeaturesTemplate(String projectPath) {
  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:$projectPath/generated/locales.g.dart';
import 'package:$projectPath/core/navigation/routes/app_pages.dart';
import 'core/navigation/routes/app_routes.dart';
import 'core/dependences/dependencies_injection.dart';
import 'core/themes/app_theme.dart';

void main() async {
  await AppDependency.init();
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
            title: LocaleKeys.main_speedara.tr,
            initialRoute: initialRoute,
            getPages: Get.find<AppPages>().getAllPages(),
            theme: myTheme,
            locale: const Locale('fr'),
            translationsKeys: AppTranslation.translations
          );
        });
  }
}

''';
}
