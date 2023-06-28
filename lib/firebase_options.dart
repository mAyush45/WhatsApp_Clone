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
    apiKey: 'AIzaSyCCtJM0h5oractNj6RhppkvYVhZ-ncYlZ8',
    appId: '1:508715944448:web:2f2422b981ad52dae826e5',
    messagingSenderId: '508715944448',
    projectId: 'whatsapp-clone-e4486',
    authDomain: 'whatsapp-clone-e4486.firebaseapp.com',
    storageBucket: 'whatsapp-clone-e4486.appspot.com',
    measurementId: 'G-3YTP54DJRW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCT5oGDPfMjhUtNwsyjS4sHzNJbuDV_8M',
    appId: '1:508715944448:android:f70a82b4e18a5539e826e5',
    messagingSenderId: '508715944448',
    projectId: 'whatsapp-clone-e4486',
    storageBucket: 'whatsapp-clone-e4486.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMhJxpigtA-8HkOeUnpsEiTDrwMEFsxg0',
    appId: '1:508715944448:ios:cecb09031a282fb1e826e5',
    messagingSenderId: '508715944448',
    projectId: 'whatsapp-clone-e4486',
    storageBucket: 'whatsapp-clone-e4486.appspot.com',
    androidClientId: '508715944448-4bj1kasq89bdfugu1ijk9l8jjn0uk16s.apps.googleusercontent.com',
    iosClientId: '508715944448-8pt2ka59tglv5ph9gs1pb7vr141n8r1c.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMhJxpigtA-8HkOeUnpsEiTDrwMEFsxg0',
    appId: '1:508715944448:ios:34ab18c167851a2fe826e5',
    messagingSenderId: '508715944448',
    projectId: 'whatsapp-clone-e4486',
    storageBucket: 'whatsapp-clone-e4486.appspot.com',
    androidClientId: '508715944448-4bj1kasq89bdfugu1ijk9l8jjn0uk16s.apps.googleusercontent.com',
    iosClientId: '508715944448-0mk3rp3jork25o89l67npe1adveqar1l.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone.RunnerTests',
  );
}
