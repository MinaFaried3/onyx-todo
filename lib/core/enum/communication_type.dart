enum CommunicationType { phone, email }

extension CommunicationTypeX on CommunicationType {
  bool get isPhone => this == .phone;

  bool get isEmail => this == .email;

  static T? handle<T>({
    required CommunicationType type,
    T? Function()? onPhone,
    T? Function()? onEmail,
    T? Function()? orElse,
  }) {
    orElse ??= () =>
        throw UnsupportedError('CommunicationType $type is not handled');

    return switch (type) {
      .phone => onPhone?.call() ?? orElse(),
      .email => onEmail?.call() ?? orElse(),
    };
  }
}
