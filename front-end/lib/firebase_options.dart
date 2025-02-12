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
    apiKey: 'AIzaSyA6dAjVzRc_ULQPFPjKEyn5JK7bsg1pWxE',
    appId: '1:240742625578:web:c23ed9cbf3b5f980472e53',
    messagingSenderId: '240742625578',
    projectId: 'pecuaria-news-d5923',
    authDomain: 'pecuaria-news-d5923.firebaseapp.com',
    storageBucket: 'pecuaria-news-d5923.appspot.com',
    measurementId: 'G-DTJ1JY4GSK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzQ_NMXNDHUDNhat6zgeb8iIJWG789s08',
    appId: '1:240742625578:android:41471a3d4022ab23472e53',
    messagingSenderId: '240742625578',
    projectId: 'pecuaria-news-d5923',
    storageBucket: 'pecuaria-news-d5923.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUTvBs-42c0hnVNBgo83V8HVQVXN-3SvQ',
    appId: '1:240742625578:ios:b416cb739d8e40b4472e53',
    messagingSenderId: '240742625578',
    projectId: 'pecuaria-news-d5923',
    storageBucket: 'pecuaria-news-d5923.appspot.com',
    androidClientId: '240742625578-lbjqduu0olbjdkb6cqoemsk255p9v4o9.apps.googleusercontent.com',
    iosClientId: '240742625578-ih900po7i1tmvpeeoqd23agsuvfvtgq4.apps.googleusercontent.com',
    iosBundleId: 'com.example.pecuariaNews',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUTvBs-42c0hnVNBgo83V8HVQVXN-3SvQ',
    appId: '1:240742625578:ios:b416cb739d8e40b4472e53',
    messagingSenderId: '240742625578',
    projectId: 'pecuaria-news-d5923',
    storageBucket: 'pecuaria-news-d5923.appspot.com',
    androidClientId: '240742625578-lbjqduu0olbjdkb6cqoemsk255p9v4o9.apps.googleusercontent.com',
    iosClientId: '240742625578-ih900po7i1tmvpeeoqd23agsuvfvtgq4.apps.googleusercontent.com',
    iosBundleId: 'com.example.pecuariaNews',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6dAjVzRc_ULQPFPjKEyn5JK7bsg1pWxE',
    appId: '1:240742625578:web:3de102e28c1c8cc7472e53',
    messagingSenderId: '240742625578',
    projectId: 'pecuaria-news-d5923',
    authDomain: 'pecuaria-news-d5923.firebaseapp.com',
    storageBucket: 'pecuaria-news-d5923.appspot.com',
    measurementId: 'G-750YT1V4PJ',
  );
}
