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
    apiKey: 'AIzaSyARsh4BeprWJotEOCbViqmDe-R9Q-NRM4I',
    appId: '1:201454016764:web:6f060e716575d1cdd11f79',
    messagingSenderId: '201454016764',
    projectId: 'basic-video-player-9ea5a',
    authDomain: 'basic-video-player-9ea5a.firebaseapp.com',
    storageBucket: 'basic-video-player-9ea5a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApiksMfHfQM3sp_uezWz8ohXD3pvHHgJw',
    appId: '1:201454016764:android:e755cad91b7f9c12d11f79',
    messagingSenderId: '201454016764',
    projectId: 'basic-video-player-9ea5a',
    storageBucket: 'basic-video-player-9ea5a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpAgzMsYLCf7Xq47AMinZy_BzHm4VcBZY',
    appId: '1:201454016764:ios:30ed1942282245b6d11f79',
    messagingSenderId: '201454016764',
    projectId: 'basic-video-player-9ea5a',
    storageBucket: 'basic-video-player-9ea5a.appspot.com',
    iosBundleId: 'com.example.basicVideoPlayer',
  );
}
