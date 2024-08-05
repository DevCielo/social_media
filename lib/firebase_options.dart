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
    apiKey: 'AIzaSyBD4mRRVfF1E_h45SIXklqfYuASXD59JjE',
    appId: '1:538593013224:web:39edb9e18b860810e1885d',
    messagingSenderId: '538593013224',
    projectId: 'twitter-clone-13blfo',
    authDomain: 'twitter-clone-13blfo.firebaseapp.com',
    storageBucket: 'twitter-clone-13blfo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDm_nrz1JgwZevxZlu12us3UvCJ4I-j_cE',
    appId: '1:538593013224:android:893fb37f6b3ed5b7e1885d',
    messagingSenderId: '538593013224',
    projectId: 'twitter-clone-13blfo',
    storageBucket: 'twitter-clone-13blfo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnGTuO1IRmhz8m42QZH2wjs3EEXJsXFhQ',
    appId: '1:538593013224:ios:673f090078972254e1885d',
    messagingSenderId: '538593013224',
    projectId: 'twitter-clone-13blfo',
    storageBucket: 'twitter-clone-13blfo.appspot.com',
    iosBundleId: 'com.example.widgetTree',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnGTuO1IRmhz8m42QZH2wjs3EEXJsXFhQ',
    appId: '1:538593013224:ios:673f090078972254e1885d',
    messagingSenderId: '538593013224',
    projectId: 'twitter-clone-13blfo',
    storageBucket: 'twitter-clone-13blfo.appspot.com',
    iosBundleId: 'com.example.widgetTree',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBD4mRRVfF1E_h45SIXklqfYuASXD59JjE',
    appId: '1:538593013224:web:bd82525075b827ffe1885d',
    messagingSenderId: '538593013224',
    projectId: 'twitter-clone-13blfo',
    authDomain: 'twitter-clone-13blfo.firebaseapp.com',
    storageBucket: 'twitter-clone-13blfo.appspot.com',
  );

}