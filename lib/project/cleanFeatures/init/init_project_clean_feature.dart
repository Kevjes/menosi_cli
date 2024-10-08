import 'package:menosi_cli/project/cleanFeatures/init/templates/dependences_templates/dependences_templates.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/events_templates/event_services_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/exception_templates/base_exception_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/app_navigation_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/app_pages_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/app_routes_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/features_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/getx_navigation_impl.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/navigation_templates/splash_controller_binding_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/pubspec_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/services_templates/form_helper.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/services_templates/get_storage_local_storage_services_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/services_templates/validators.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/ui_templates/custom_app_bar_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/ui_templates/image_component_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/ui_templates/loading_widget_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/utils_templates/app_colors_templates.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/utils_templates/app_constant_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/utils_templates/app_dimensions_template.dart';
import 'package:menosi_cli/project/cleanFeatures/init/templates/utils_templates/get_extension_template.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../../../app/constants.dart';
import '../features/feature.dart';
import '../../../langify/langify.dart';
import 'templates/main_clean_feature_template.dart';
import 'templates/services_templates/dio_network_services_template.dart';
import 'templates/services_templates/local_storage_service_template.dart';
import 'templates/services_templates/network_service_template.dart';
import 'templates/theme_templates/app_theme_template.dart';
import 'templates/ui_templates/custom_button_template.dart';
import 'templates/ui_templates/custom_text_field_template.dart';
import 'templates/ui_templates/not_found_screen_template.dart';
import 'templates/ui_templates/splash_controller_template.dart';
import 'templates/ui_templates/splash_screen_template.dart';
import 'templates/utils_templates/app_images_template.dart';

void initProjectCleanFeatures() {
  print('${green}Init project clean features');

  final currentDir = Directory.current;
  Directory(p.join(currentDir.path, 'lib')).deleteSync(recursive: true);
  print('Project clean lib folder');
  final appName = getAppNameFromPubspec('${Directory.current.path}/pubspec.yaml');

  // Define the paths for the new feature
  final featuresPath = p.join(currentDir.path, 'lib', 'features');
  final corePath = p.join(currentDir.path, 'lib', 'core');

  // Create the directory structure
  Directory(p.join(currentDir.path, 'assets', 'images')).createSync(recursive: true);
  Directory(p.join(currentDir.path, 'assets', 'icons')).createSync(recursive: true);
  Directory(featuresPath).createSync(recursive: true);
  Directory(corePath).createSync(recursive: true);
  Directory(p.join(corePath, 'navigation')).createSync(recursive: true);
  Directory(p.join(corePath, 'dependences')).createSync(recursive: true);
  Directory(p.join(corePath, 'events')).createSync(recursive: true);
  Directory(p.join(corePath, 'navigation', 'routes')).createSync(recursive: true);
  Directory(p.join(corePath, 'navigation', 'bindings')).createSync(recursive: true);
  Directory(p.join(corePath, 'exceptions')).createSync(recursive: true);
  Directory(p.join(corePath, 'ui', 'screens', 'notFoundScreen')).createSync(recursive: true);
  Directory(p.join(corePath, 'ui', 'screens', 'splashScreen', 'controllers')).createSync(recursive: true);
  Directory(p.join(corePath, 'ui', 'widgets')).createSync(recursive: true);
  Directory(p.join(corePath, 'ui', 'interfaces')).createSync(recursive: true);
  Directory(p.join(corePath, 'services', 'form')).createSync(recursive: true);
  Directory(p.join(corePath, 'services', 'localServices')).createSync(recursive: true);
  Directory(p.join(corePath, 'services', 'networkServices')).createSync(recursive: true);
  Directory(p.join(corePath, 'themes')).createSync(recursive: true);
  Directory(p.join(corePath, 'utils')).createSync(recursive: true);


  File(p.join(currentDir.path, 'pubspec.yaml')).writeAsStringSync(pubspecTemplate(appName));
  print('created ${currentDir.path}/pubspec.yaml');
  File(p.join(currentDir.path, 'lib', 'main.dart')).writeAsStringSync(mainCleanFeaturesTemplate(appName));
  print('created ${currentDir.path}/lib/main.dart');

  File(p.join(corePath, 'dependences', 'app_dependences.dart')).writeAsStringSync(dependencesTemplate());
  print('created $corePath/dependences/app_dependences.dart');

  File(p.join(corePath, 'events', 'app_events_service.dart')).writeAsStringSync(eventBusServiceTemplate());
  print('created $corePath/events/app_events_service.dart');

  File(p.join(corePath, 'exceptions', 'base_exception.dart')).writeAsStringSync(baseExceptionTemplate());
  print('created $corePath/exceptions/base_exception.dart');

  File(p.join(corePath, 'navigation', 'bindings', 'splash_controller_binding.dart')).writeAsStringSync(splashControllerBindingTemplate());
  print('created $corePath/navigation/bindings/splash_controller_binding.dart');
  File(p.join(corePath, 'navigation', 'routes', 'app_routes.dart')).writeAsStringSync(appRoutesTemplate());
  print('created $corePath/navigation/routes/app_routes.dart');
  File(p.join(corePath, 'navigation', 'routes', 'app_pages.dart')).writeAsStringSync(appPagesTemplate());
  print('created $corePath/navigation/routes/app_pages.dart');
  File(p.join(corePath, 'navigation', 'routes', 'features_pages.dart')).writeAsStringSync(featuresPageTemplate());
  print('created $corePath/navigation/routes/features_pages.dart');
  File(p.join(corePath, 'navigation', 'app_navigation.dart')).writeAsStringSync(appNavigationTemplate());
  print('created $corePath/navigation/app_navigation.dart');
  File(p.join(corePath, 'navigation', 'getx_navigation_impl.dart')).writeAsStringSync(getxNavigationImplTemplate());
  print('created $corePath/navigation/getx_navigation_impl.dart');

  File(p.join(corePath, 'services', 'localServices', 'get_storage_local_storage_service.dart')).writeAsStringSync(getStorageLocalStorageServiceTemplate());
  print('created $corePath/services/localServices/get_storage_local_storage_service.dart');
  File(p.join(corePath, 'services', 'localServices', 'local_storage_service.dart')).writeAsStringSync(localStorageServiceTemplate());
  print('created $corePath/services/localServices/local_storage_service.dart');
  File(p.join(corePath, 'services', 'networkServices', 'dio_network_service.dart')).writeAsStringSync(dioNetworkServiceTemplate());
  print('created $corePath/services/networkServices/dio_network_service.dart');
  File(p.join(corePath, 'services', 'networkServices', 'network_service.dart')).writeAsStringSync(networkServiceTemplate());
  print('created $corePath/services/networkServices/network_service.dart');
    File(p.join(corePath, 'services', 'form', 'form_helper.dart')).writeAsStringSync(formHeperTemplate());
  print('created $corePath/services/form/form_helper.dart');
    File(p.join(corePath, 'services', 'form', 'validators.dart')).writeAsStringSync(validatorsTemplate);
  print('created $corePath/services/form/validators.dart');

  File(p.join(corePath, 'themes', 'app_themes.dart')).writeAsStringSync(appThemeTemplate());
  print('created $corePath/themes/app_theme.dart');

  File(p.join(corePath, 'utils', 'app_colors.dart')).writeAsStringSync(AppColorsTemplate());
  print('created $corePath/utils/app_colors.dart');
  File(p.join(corePath, 'utils', 'app_constants.dart')).writeAsStringSync(appConstantTemplate());
  print('created $corePath/utils/app_constants.dart');
  File(p.join(corePath, 'utils', 'app_dimensions.dart')).writeAsStringSync(AppDimensionsTemplate());
  print('created $corePath/utils/app_dimensions.dart');
  File(p.join(corePath, 'utils', 'app_images.dart')).writeAsStringSync(appImagesTemplate());
  print('created $corePath/utils/app_images.dart');
  // File(p.join(corePath, 'utils', 'app_responsive.dart')).writeAsStringSync(responsiveTemplate());
  // print('created $corePath/utils/app_responsive.dart');
  File(p.join(corePath, 'utils', 'getx_extensions.dart')).writeAsStringSync(getExtensionTemplate());
  print('created $corePath/utils/getx_extensions.dart');

  File(p.join(corePath, 'ui', 'interfaces', 'feature_widget_interface.dart')).writeAsStringSync(loadingWidgetTemplate());
  print('created $corePath/ui/interfaces/feature_widget_interface.dart');
  File(p.join(corePath, 'ui', 'widgets', 'custom_app_bar.dart')).writeAsStringSync(customAppBarTemplate());
  print('created $corePath/ui/widgets/custom_app_bar.dart');
  File(p.join(corePath, 'ui', 'widgets', 'custom_button.dart')).writeAsStringSync(customButtonTemplate());
  print('created $corePath/ui/widgets/custom_button.dart');
  File(p.join(corePath, 'ui', 'widgets', 'custom_text_field.dart')).writeAsStringSync(customTextFieldTemplate());
  print('created $corePath/ui/widgets/custom_text_field.dart');
  File(p.join(corePath, 'ui', 'widgets', 'image_component.dart')).writeAsStringSync(imageComponentTemplate());
  print('created $corePath/ui/widgets/image_component.dart');
  File(p.join(corePath, 'ui', 'widgets', 'loading_widget.dart')).writeAsStringSync(loadingWidgetTemplate());
  print('created $corePath/ui/widgets/loading_widget.dart');
  


  File(p.join(corePath, 'ui', 'screens', 'notFoundScreen', 'not_found_screen.dart')).writeAsStringSync(notFoundScreenTemplate());
  print('created $corePath/ui/screens/notFoundScreen/not_found_screen.dart');

  File(p.join(corePath, 'ui', 'screens', 'splashScreen', 'splash_screen.dart')).writeAsStringSync(splashScreenTemplate());
  print('created $corePath/ui/screens/splashScreen/splash_screen.dart');
  File(p.join(corePath, 'ui', 'screens', 'splashScreen','controllers', 'splash_controller.dart')).writeAsStringSync(splashControllerTemplate());
  print('created $corePath/ui/screens/splashScreen/controllers/splash_controller.dart');

  createFeature('home');
  
  print('Project clean features initialized');
}
