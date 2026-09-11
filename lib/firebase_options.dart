import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyB_ONYX_TODO_WEB_KEY_PLACEHOLDER',
    ),
    appId: '1:1010747664484:web:654b1f6cb7d934aa733e8b',
    messagingSenderId: '1010747664484',
    projectId: 'onyx-todo',
    authDomain: 'onyx-todo.firebaseapp.com',
    storageBucket: 'onyx-todo.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyB_ONYX_TODO_ANDROID_KEY_PLACEHOLDER',
    ),
    appId: '1:1010747664484:android:e154f48312e096da733e8b',
    messagingSenderId: '1010747664484',
    projectId: 'onyx-todo',
    storageBucket: 'onyx-todo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyB_ONYX_TODO_IOS_KEY_PLACEHOLDER',
    ),
    appId: '1:1010747664484:ios:6c8cfbb71333e60a733e8b',
    messagingSenderId: '1010747664484',
    projectId: 'onyx-todo',
    storageBucket: 'onyx-todo.firebasestorage.app',
    iosBundleId: 'com.onyx.todo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyB_ONYX_TODO_IOS_KEY_PLACEHOLDER',
    ),
    appId: '1:1010747664484:ios:6c8cfbb71333e60a733e8b',
    messagingSenderId: '1010747664484',
    projectId: 'onyx-todo',
    storageBucket: 'onyx-todo.firebasestorage.app',
    iosBundleId: 'com.onyx.todo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyB_ONYX_TODO_WEB_KEY_PLACEHOLDER',
    ),
    appId: '1:1010747664484:web:654b1f6cb7d934aa733e8b',
    messagingSenderId: '1010747664484',
    projectId: 'onyx-todo',
    authDomain: 'onyx-todo.firebaseapp.com',
    storageBucket: 'onyx-todo.firebasestorage.app',
  );
}
