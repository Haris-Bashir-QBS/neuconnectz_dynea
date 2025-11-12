import 'package:neuconnectz_dynea/src/core/utils/regular_expressions.dart';

import '../constants/app_errors.dart';

typedef ValidatorFunction = String? Function(String? value);

final class AppValidators {
  AppValidators._();

  static ValidatorFunction email() {
    return (value) {
      if (value == null || value.isEmpty) return AppErrors.emptyField;
      if (!RegularExpressions.emailRegex.hasMatch(value)) {
        return AppErrors.invalidEmail;
      }
      return null;
    };
  }

  static ValidatorFunction required() {
    return (value) =>
        (value == null || value.isEmpty) ? AppErrors.emptyField : null;
  }

  static ValidatorFunction minLength(int minLength) {
    return (value) =>
        (value != null && value.length < minLength)
            ? AppErrors.shortPassword
            : null;
  }

  static ValidatorFunction combine(List<ValidatorFunction> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
