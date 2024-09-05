import 'dart:io';

import 'package:menosi_cli/app/constants.dart';
import 'package:menosi_cli/featureEdpointWorflow/application/generate_command.dart';
import 'package:menosi_cli/featureEdpointWorflow/domain/update_feature_constant.dart';
import 'package:menosi_cli/featureEdpointWorflow/infrastructure/update_repository_impl.dart';
import 'package:menosi_cli/featureEdpointWorflow/more/command_file_creator.dart';
import 'package:menosi_cli/featureEdpointWorflow/navigation/update_bindings.dart';

import '../app/functions.dart';
import 'application/generate_usecase.dart';
import 'dependences/update_dependences.dart';
import 'domain/entity_generator.dart';
import 'domain/update_repository.dart';
import 'infrastructure/generate_model.dart';
import 'more/response_file_creator.dart';
import 'ui/update_controller.dart';

void generateEndPointWorkflow(String featureName, String endpointName,
    [String? pageName]) {
  featureName = transformToLowerCamelCase(featureName);
  endpointName = transformToLowerCamelCase(endpointName);

  final featurePath = "${Directory.current.path}/lib/features/$featureName";
  final _commandFilePath =
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_command.json';
  final _responseFilePath =
      'assets/endpoints/$featureName/${convertToSnakeCase(endpointName)}_response.json';

  if (!fileExists(_commandFilePath)) {
    print('${red}Command file not found in $_commandFilePath${reset}');
    print(
        '${blue}Starting creating Command file for $endpointName on $featureName${reset}');
    createEndpointCommandFile(featureName, endpointName, _commandFilePath);
  }

  if (!fileExists(_responseFilePath)) {
    print('${red}Response file not found in $_responseFilePath${reset}');
    print(
        '${blue}Starting creating Response file for $endpointName on $featureName${reset}');
    createEndpointResponseFile(featureName, endpointName, _responseFilePath);
  }

  final commandJson = readJson(_commandFilePath);
  final responseJson = readJson(_responseFilePath);

  final entityName = transformToUpperCamelCase(
      responseJson['responseName'] ?? convertToSnakeCase(endpointName));
  final methodName = endpointName;
  final endpointConstantName =
      '${transformToLowerCamelCase(endpointName)}${transformToUpperCamelCase((commandJson['method'] as String).toLowerCase())}Uri';

  if ((responseJson['data'] as Map).isNotEmpty) {
    generateEntity(responseJson, entityName, featurePath);
  }
  if ((responseJson['data'] as Map).isNotEmpty) {
    generateModel(responseJson, entityName, featurePath);
  }
  updateRepository(
      featurePath, featureName, methodName, entityName, commandJson,
      returnValue: (responseJson['data'] as Map).isNotEmpty);
  updateRepositoryImpl(featurePath, featureName, methodName, entityName,
      commandJson, endpointConstantName,
      returnValue: (responseJson['data'] as Map).isNotEmpty);
  addEndpointToFeatureConstants(
      featureName, commandJson, featurePath, endpointConstantName);
  generateUseCase(methodName, featureName, entityName, featurePath, commandJson,
      returnValue: (responseJson['data'] as Map).isNotEmpty);

  generateCommand(commandJson, entityName, featurePath);

  if (pageName != null) {
    pageName = transformToLowerCamelCase(pageName);
    // updateBinding(
    //     "$featurePath/navigation/bindings/${convertToSnakeCase(pageName)}_controller_binding.dart");
    updateEndpointDependeces(
        "$featurePath/dependences/${convertToSnakeCase(featureName)}_dependencies.dart",
        endpointName);
    updateController(
        "$featurePath/ui/$pageName/controllers/${convertToSnakeCase(pageName)}_controller.dart",
        endpointName,
        commandJson);
  }

  // Mettre à jour le controller
  // updateController(featurePath, methodName, entityName);

  // // Mettre à jour les dépendances
  // updateDependencies(featurePath, methodName, entityName);
}
