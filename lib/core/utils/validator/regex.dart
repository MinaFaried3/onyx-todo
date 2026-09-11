abstract final class RegExpSource {
  /*
  * ^                               start anchor
    (?=(.*[a-z]){2,})               lowercase letters. {2,} indicates that you want 2 of this group
    (?=(.*[A-Z]){1,})               uppercase letters. {1,} indicates that you want 1 of this group
    (?=(.*[0-9]){1,})               numbers. {1,} indicates that you want 1 of this group
    (?=(.*[!@#$%^&*()\-__+.]){1,})  all the special characters in the [] fields. The ones used by regex are escaped by using the \ or the character itself. {1,} is redundant, but good practice, in case you change that to more than 1 in the future. Also keeps all the groups consistent
    {8,}                            indicates that you want 8 or more
    $                               end anchor
  * */
  static const String emailEditing =
      r'^[a-zA-Z0-9_.+-]*(\@[a-zA-Z0-9-]*(\.[a-zA-Z0-9-]*)*)?$';
  static const String emailSubmitted =
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$';
  static const String phoneNumberEditing = r"^(01)?[0-9]{0,11}$";
  static const String phoneNumberEditingMustStartWithZeroOne =
      r"^(01)[0-9]{0,9}$";
  static const String phoneNumberSubmitted = r"^01[0-9]{9}$";
  static const String somaliPhoneNumberSubmitted =
      r"^(?:\+?252|00252|0(?:6|7|9)|00[679])\d{7,9}$";
  static const String passwordSubmitted =
      r'^(?=(.*[a-z]){2,})(?=(.*[0-9]){1,}).{8,}$';
}

abstract final  class AppRegExp{
  static final RegExp emailEditing = RegExp(RegExpSource.emailEditing);
  static final RegExp emailSubmitted = RegExp(RegExpSource.emailSubmitted);
  static final RegExp phoneEditing = RegExp(RegExpSource.phoneNumberEditing);
  static final RegExp phoneSubmitted = RegExp(
    RegExpSource.phoneNumberSubmitted,
  );
  static final RegExp password = RegExp(RegExpSource.passwordSubmitted);
}