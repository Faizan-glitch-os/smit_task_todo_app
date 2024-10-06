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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwWnUJXiV5IDj9z9Kr9ZV0KFnAq7Rfgvw',
    appId: '1:344993910153:android:a9b1869fbdeada4deae558',
    messagingSenderId: '344993910153',
    projectId: 'smit-todo-app',
    storageBucket: 'smit-todo-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfIoBe4967ywslrp57rzC8VRjzPJK7k_Q',
    appId: '1:344993910153:ios:8961082a4ab6465aeae558',
    messagingSenderId: '344993910153',
    projectId: 'smit-todo-app',
    storageBucket: 'smit-todo-app.appspot.com',
    iosBundleId: 'com.example.smitTaskTodoApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDweTJ8aQs2sqMYD_aSyxd4WRjfuSqUajc',
    appId: '1:344993910153:web:2c27de74ca3b1a02eae558',
    messagingSenderId: '344993910153',
    projectId: 'smit-todo-app',
    authDomain: 'smit-todo-app.firebaseapp.com',
    storageBucket: 'smit-todo-app.appspot.com',
  );

}