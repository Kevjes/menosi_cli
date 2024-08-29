import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/featureEdpointWorflow/domain/update_feature_constant.dart';
import 'package:menosi_cli/featureEdpointWorflow/infrastructure/update_repository_impl.dart';

import '../app/functions.dart';
import 'application/generate_usecase.dart';
import 'domain/entity_generator.dart';
import 'domain/update_repository.dart';
import 'infrastructure/generate_model.dart';

void generateEndPointWorkflow(String featureName, String endpointName) {
  featureName = transformToLowerCamelCase(featureName);
  endpointName = transformToLowerCamelCase(endpointName);

  final featurePath = "${Directory.current.path}/lib/features/$featureName";
  final _commandFilePath =
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_command.json';
  final _responseFilePath =
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_response.json';

  if(!fileExists( _commandFilePath)) {
    print('${red}Command file not found in $_commandFilePath${reset}');
    print('${yellow}You can create one with this command :${reset}');
    print('${cyan}menosi generate command $featureName $endpointName${reset}');
    exit(1);
  }

  if(!fileExists( _responseFilePath)) {
    print('${red}Response file not found in $_responseFilePath${reset}');
    print('${yellow}You can create one with this command :${reset}');
    print('${cyan}menosi generate response $featureName $endpointName${reset}');
    exit(1);
  }

  final commandJson = readJson(_commandFilePath);
  final responseJson = readJson(_responseFilePath);

  final entityName = transformToUpperCamelCase(responseJson['responseName']);
  final methodName = endpointName;
  final endpointConstantName =
      '${transformToLowerCamelCase(featureName)}${transformToUpperCamelCase((commandJson['method'] as String).toLowerCase())}Uri';

  generateEntity(responseJson, entityName, featurePath);
  generateModel(responseJson, entityName, featurePath);
  updateRepository(
      featurePath, featureName, methodName, entityName, commandJson);
  updateRepositoryImpl(featurePath, featureName, methodName, entityName,
      commandJson, endpointConstantName);
  addEndpointToFeatureConstants(
      featureName, commandJson, featurePath, endpointConstantName);
  generateUseCase(
      methodName, featureName, entityName, featurePath, commandJson);

  // Mettre à jour le controller
  // updateController(featurePath, methodName, entityName);

  // // Mettre à jour les dépendances
  // updateDependencies(featurePath, methodName, entityName);
}
