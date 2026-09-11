import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration — pass `null` to [CoreConfiguration.firebase]
/// to disable Firebase entirely.
///
/// ```dart
/// firebase: FirebaseConfiguration(
///   options: DefaultFirebaseOptions.currentPlatform,
///   analytics: true,
///   crashlytics: true,
///   performance: true,
/// ),
/// ```
class FirebaseConfig {
  //! Firebase initialization options — comes from `firebase_options.dart` in each project.
  final FirebaseOptions options;

  //! Enable Firebase Analytics.
  final bool analytics;

  //! Enable Firebase Crashlytics + automatic Flutter/Dart error reporting.
  final bool crashlytics;

  //! Enable Firebase Performance Monitoring.
  final bool performance;

  const FirebaseConfig({
    required this.options,
    this.analytics = true,
    this.crashlytics = true,
    this.performance = true,
  });
}
