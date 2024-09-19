import 'dart:io';
import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/app/functions.dart';
import 'package:path/path.dart' as p;

void removeFeature(String featureName){
  final currentDir = Directory.current.path;
  featureName = transformToLowerCamelCase(featureName);
  final snakeFeatureName = convertToSnakeCase(featureName);

  Directory(p.join(currentDir, 'lib', 'features', featureName)).deleteSync(recursive: true);
  print("${green}Removed $featureName");
}