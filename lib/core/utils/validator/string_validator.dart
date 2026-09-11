import 'package:onyx_todo/core/fp/fp.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/utils/validator/regex.dart';
import 'package:onyx_todo/core/utils/validator/sql_injection_gaurd.dart';
import 'package:equatable/equatable.dart';
part 'regex_validator_types.dart';

sealed class StringValidator extends Equatable {
  bool isValid(String? text);

  /// Validates [text] and returns an [Option<String>] containing the valid string or [none()].
  Option<String> validateOption(String? text) =>
      isValid(text) && text != null ? Option.of(text) : const Option.none();

  /// Converts this validator to a composable [Predicate<String?>].
  Predicate<String?> get toPredicate => isValid;

  const StringValidator();
}

sealed class RegexValidator extends StringValidator {
  final String regexSource;

  const RegexValidator({required this.regexSource});

  @override
  bool isValid(String? text) {
    if (text == null) return false;

    if (SqlInjectionGuard.isSafe(text) case false) {
      return false;
    }

    try {
      final RegExp regExp = RegExp(regexSource);
      final matches = regExp.allMatches(text);
      for (var match in matches) {
        if (match.start == 0 && match.end == text.length) {
          return true;
        }
      }
      return false;
    } catch (error) {
      Printer.print(error.toString(), color: ConsoleColor.brightRed);
      return false;
    }
  }

  @override
  List<Object> get props => [regexSource];
}
