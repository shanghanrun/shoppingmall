// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBVG5_HLs-X9QpLdyhFaZsHpNHmDlwCKjc',
    appId: '1:255154096940:web:8e46de59783b0f0835ba89',
    messagingSenderId: '255154096940',
    projectId: 'choco-firebase-ex001',
    authDomain: 'choco-firebase-ex001.firebaseapp.com',
    databaseURL: 'https://choco-firebase-ex001-default-rtdb.firebaseio.com',
    storageBucket: 'choco-firebase-ex001.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVQOTwvG9iFU5aNNjaeEAGnXn6Ip1pHLc',
    appId: '1:255154096940:android:743a12bddc263b7235ba89',
    messagingSenderId: '255154096940',
    projectId: 'choco-firebase-ex001',
    databaseURL: 'https://choco-firebase-ex001-default-rtdb.firebaseio.com',
    storageBucket: 'choco-firebase-ex001.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChwn4ZxFdENcHCBJlDHuaUfcD9cGHIGVI',
    appId: '1:255154096940:ios:a767b715a6ea74a135ba89',
    messagingSenderId: '255154096940',
    projectId: 'choco-firebase-ex001',
    databaseURL: 'https://choco-firebase-ex001-default-rtdb.firebaseio.com',
    storageBucket: 'choco-firebase-ex001.appspot.com',
    iosBundleId: 'com.example.shoppingmall',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChwn4ZxFdENcHCBJlDHuaUfcD9cGHIGVI',
    appId: '1:255154096940:ios:1decf9677849233d35ba89',
    messagingSenderId: '255154096940',
    projectId: 'choco-firebase-ex001',
    databaseURL: 'https://choco-firebase-ex001-default-rtdb.firebaseio.com',
    storageBucket: 'choco-firebase-ex001.appspot.com',
    iosBundleId: 'com.example.shoppingmall.RunnerTests',
  );
}