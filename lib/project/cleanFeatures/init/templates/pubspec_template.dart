String pubspecTemplate(String appName) {
  return '''
name: $appName
version: 1.0.0+1
publish_to: none
description: A new Flutter project.
environment: 
  sdk: '>=3.4.4 <4.0.0'

dependencies: 
  cupertino_icons: ^1.0.6
  get: 4.6.6
  get_storage: 2.1.1
  dartz: 0.10.1
  shimmer: ^3.0.0
  cached_network_image: ^3.4.0
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  animated_theme_switcher: ^2.0.10
  flutter_spinkit: ^5.2.1
  responsive_framework: ^1.5.1
  dio: ^5.7.0
  talker_dio_logger: ^4.4.1
  dio_cache_interceptor: ^3.5.0
  talker: ^4.4.1
  dio_cache_interceptor_file_store: ^1.2.3
  loading_animation_widget: ^1.3.0

  flutter: 
    sdk: flutter

dev_dependencies: 
  flutter_lints: 4.0.0
  flutter_test: 
    sdk: flutter

flutter: 
  assets: 
    - assets/
    - assets/images/
    - assets/icons/
  uses-material-design: true


''';
}
