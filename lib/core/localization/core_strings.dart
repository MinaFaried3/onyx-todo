/// Localization keys مستخدمة داخل onyx_todo فقط.
/// هذه keys يُترجمها الـ UI في كل مشروع — الـ package لا يحتوي نصوصاً مباشرة.
abstract class CoreStrings {
  // error handler
  static const String success = 'success';
  static const String created = 'created';
  static const String badRequestError = 'bad_request_error';
  static const String noContent = 'no_content';
  static const String paymentRequiredError = 'payment_required_error';
  static const String notImplementedError = 'not_implemented_error';
  static const String forbiddenError = 'forbidden_error';
  static const String unauthorizedError = 'unauthorized_error';
  static const String notFoundError = 'not_found_error';
  static const String conflictError = 'conflict_error';
  static const String internalServerError = 'internal_server_error';
  static const String unknownError = 'unknown_error';
  static const String timeoutError = 'timeout_error';
  static const String defaultError = 'default_error';
  static const String cacheError = 'cache_error';
  static const String noInternetError = 'no_internet_error';
  static const String invalidDataError = 'invalid_data_error';

  // gender
  static const String male = 'male';
  static const String female = 'female';

  // location
  static const String locationServiceIsDisabled = 'location_service_is_disabled';
  static const String locationPermissionIsDeniedForever = 'location_permission_is_denied_forever';
  static const String locationPermissionIsDenied = 'location_permission_is_denied';

  // image picker
  static const String camera = 'camera';
  static const String gallery = 'gallery';
  static const String chooseImageSource = 'choose_image_source';
  static const String cancel = 'cancel';

  // validation & common strings
  static const String cannotBeEmpty = 'cannot_be_empty';
  static const String phoneInvalid = 'phone_invalid';
  static const String emailInvalid = 'email_invalid';
  static const String required = 'required';
  static const String appTitle = 'app_title';

  // navigation
  static const String noRoute = 'no_route';
  static const String goHome = 'go_home';
}
