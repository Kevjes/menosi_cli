import 'package:menosi_cli/app/functions.dart';

String exceptionTemplate(String featureName) {
  return """
import '../../../../../core/exceptions/base_exception.dart';

class ${capitalize(featureName)}Exception extends BaseException {
  ${capitalize(featureName)}Exception(String message) : super(message);
}

""";
}
