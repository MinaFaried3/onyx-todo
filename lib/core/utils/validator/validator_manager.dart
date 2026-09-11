import 'package:easy_localization/easy_localization.dart';
import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:onyx_todo/core/utils/validator/string_validator.dart';

abstract class ValidatorManager {
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return CoreStrings.cannotBeEmpty.tr();
    }
    //
    // if (phone.length < AppConstants.phoneNumberLength) {
    //   return AppStrings.phoneLengthNotValid.tr();
    // }

    final validPhone = const SomaliPhoneNumberSubmitRegexValidator().isValid(
      phone,
    );
    if (!validPhone) {
      return CoreStrings.phoneInvalid.tr();
    }

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return CoreStrings.cannotBeEmpty.tr();
    }

    final validEmail = const EmailSubmitRegexValidator().isValid(email);
    if (!validEmail) {
      return CoreStrings.emailInvalid.tr();
    }

    return null;
  }

  static String? isRequired(String? s) =>
      (s == null || s.trim().isEmpty) ? CoreStrings.required.tr() : null;
}
