import 'dart:io';

import '../app/functions.dart';
import 'application/generate_usecase.dart';
import 'domain/entity_generator.dart';
import 'domain/update_repository.dart';
import 'infrastructure/generate_model.dart';

void generateEndPointWorkflow(String featureName, String endpointName) {

  featureName = transformToLowerCamelCase(featureName);
  endpointName = transformToLowerCamelCase(endpointName);

  final featurePath = "${Directory.current.path}/lib/features/$featureName";

  final commandJson = readJson(
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_command.json');
  final responseJson = readJson(
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_response.json');

  final entityName = transformToUpperCamelCase(responseJson['responseName']);
  final modelName = '${capitalize(endpointName)}Model';
  final methodName = endpointName;

  generateEntity(responseJson, entityName, featurePath);
  generateModel(responseJson, modelName, featurePath);
  updateRepository(featurePath, featureName, methodName, entityName, commandJson);
  generateUseCase(
      methodName, featureName, entityName, featurePath, commandJson);

  // Mettre à jour le controller
  // updateController(featurePath, methodName, entityName);

  // // Mettre à jour les dépendances
  // updateDependencies(featurePath, methodName, entityName);
}
