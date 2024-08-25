String splashControllerBindingTemplate() {
  return '''
import 'package:get/get.dart';
import '../../presentation/pages/splashScreen/controllers/splash_controller.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        Get.find(),
      ),
    );
  }
}
''';
}
