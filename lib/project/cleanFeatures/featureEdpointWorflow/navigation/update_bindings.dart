import 'dart:io';

import '../../../../app/constants.dart';

void updateBinding(String bindingPath){
  final file = File(bindingPath);
  if (file.existsSync()) {
    final content = file.readAsStringSync();
    final updateContent = content.replaceFirst("Get.find()", """Get.find(), Get.find()""");

    file.writeAsStringSync(updateContent);
    print('${yellow}Binding updated at $bindingPath${reset}');
  } else {
    print('${red}Binding file not found at $bindingPath${reset}');
  }

}