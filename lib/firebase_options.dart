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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDEL-xY5pvQHLQ8JxVFJ-TyfPQBjNmzlnY',
    appId: '1:474057687798:web:a7077f9a8353d6c6cee2d7',
    messagingSenderId: '474057687798',
    projectId: 'eventima-93e43',
    authDomain: 'eventima-93e43.firebaseapp.com',
    storageBucket: 'eventima-93e43.appspot.com',
    measurementId: 'G-KYWYZXQ74T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtZ8LNymTtBPvVkN2jP4IP6aEm7Iwl1mM',
    appId: '1:474057687798:android:e52ed00d449f6ac1cee2d7',
    messagingSenderId: '474057687798',
    projectId: 'eventima-93e43',
    storageBucket: 'eventima-93e43.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7N7gAg2rM06hzxo-rRe2X1wf51xWKig4',
    appId: '1:474057687798:ios:794c3b552da5902bcee2d7',
    messagingSenderId: '474057687798',
    projectId: 'eventima-93e43',
    storageBucket: 'eventima-93e43.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGcSort0d-umxoL4glKRhOqA4udttxKE0',
    appId: '1:676071061187:ios:6b08e4f590d5a998c6d476',
    messagingSenderId: '676071061187',
    projectId: 'eventima-e61c6',
    storageBucket: 'eventima-e61c6.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDEL-xY5pvQHLQ8JxVFJ-TyfPQBjNmzlnY',
    appId: '1:474057687798:web:83f677356a0e4ca4cee2d7',
    messagingSenderId: '474057687798',
    projectId: 'eventima-93e43',
    authDomain: 'eventima-93e43.firebaseapp.com',
    storageBucket: 'eventima-93e43.appspot.com',
    measurementId: 'G-2VRXMDQKM7',
  );

}