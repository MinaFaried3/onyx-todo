part of 'string_validator.dart';

class EmailEditingRegexValidator extends RegexValidator {
  const EmailEditingRegexValidator(
      {super.regexSource = RegExpSource.emailEditing});
}

class EmailSubmitRegexValidator extends RegexValidator {
  const EmailSubmitRegexValidator(
      {super.regexSource = RegExpSource.emailSubmitted});
}

class PhoneNumberEditingRegexValidator extends RegexValidator {
  const PhoneNumberEditingRegexValidator(
      {super.regexSource = RegExpSource.phoneNumberEditing});
}

class PhoneNumberSubmitRegexValidator extends RegexValidator {
  const PhoneNumberSubmitRegexValidator(
      {super.regexSource = RegExpSource.phoneNumberSubmitted});
}

class SomaliPhoneNumberSubmitRegexValidator extends RegexValidator {
  const SomaliPhoneNumberSubmitRegexValidator(
      {super.regexSource = RegExpSource.somaliPhoneNumberSubmitted});
}

class PasswordSubmitRegexValidator extends RegexValidator {
  const PasswordSubmitRegexValidator(
      {super.regexSource = RegExpSource.passwordSubmitted});
}
