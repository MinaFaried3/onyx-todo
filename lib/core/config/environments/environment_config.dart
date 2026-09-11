/// Runtime environment for the application.
///
/// The package doesn't depend on `Flavor` — uses [Environment] only
/// for internal decisions like enabling HTTP overrides or changing logger behavior.
enum Environment {
  dev,
  prod;

  bool get isDev => this == Environment.dev;
  bool get isProd => this == Environment.prod;
}
