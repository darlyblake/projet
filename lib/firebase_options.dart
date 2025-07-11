// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCm1M58mHj7cJNlprG_-YFrMXjA5lnMNRs',
    appId: '1:646569768377:web:06ffbf3e12ca10c3533268',
    messagingSenderId: '646569768377',
    projectId: 'edustore-8a796',
    authDomain: 'edustore-8a796.firebaseapp.com',
    storageBucket: 'edustore-8a796.firebasestorage.app',
    measurementId: 'G-4HGWF4E89R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE0oGaM1oPhs0x0v9xA6rcHZvPKn6IxrY',
    appId: '1:646569768377:android:a63f0a745387f7f4533268',
    messagingSenderId: '646569768377',
    projectId: 'edustore-8a796',
    storageBucket: 'edustore-8a796.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPimVhAirGf8vD6RUDgV95A3xV-60xPuk',
    appId: '1:646569768377:ios:a4ed06a9d9332d2e533268',
    messagingSenderId: '646569768377',
    projectId: 'edustore-8a796',
    storageBucket: 'edustore-8a796.firebasestorage.app',
    iosBundleId: 'com.example.edustore',
  );
}
