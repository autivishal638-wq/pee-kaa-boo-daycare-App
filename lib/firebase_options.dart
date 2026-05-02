// filepath: pee_ka_boo/lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase configuration options for the app.
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

  // Web configuration - using placeholder values
  // In production, replace with actual values from Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBZzROimo1xRUCxCIko7QeqHAYxpWcMVv8",
    appId: "1:1020726856378:web:placeholder",
    messagingSenderId: "1020726856378",
    projectId: "pee-ka-boo-play-house",
    authDomain: "pee-ka-boo-play-house.firebaseapp.com",
    storageBucket: "pee-ka-boo-play-house.firebasestorage.app",
  );

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBZzROimo1xRUCxCIko7QeqHAYxpWcMVv8",
    appId: "1:1020726856378:android:65b110bab3b1f3f2651083",
    messagingSenderId: "1020726856378",
    projectId: "pee-ka-boo-play-house",
    storageBucket: "pee-ka-boo-play-house.firebasestorage.app",
  );

  // iOS configuration (placeholder - get from Firebase Console)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBZzROimo1xRUCxCIko7QeqHAYxpWcMVv8",
    appId: "1:1020726856378:ios:placeholder",
    messagingSenderId: "1020726856378",
    projectId: "pee-ka-boo-play-house",
    storageBucket: "pee-ka-boo-play-house.firebasestorage.app",
    iosBundleId: "com.peekaboo.playhouse",
  );

  // macOS configuration (placeholder)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBZzROimo1xRUCxCIko7QeqHAYxpWcMVv8",
    appId: "1:1020726856378:macos:placeholder",
    messagingSenderId: "1020726856378",
    projectId: "pee-ka-boo-play-house",
    storageBucket: "pee-ka-boo-play-house.firebasestorage.app",
    iosBundleId: "com.peekaboo.playhouse",
  );

  // Windows configuration (placeholder)
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyBZzROimo1xRUCxCIko7QeqHAYxpWcMVv8",
    appId: "1:1020726856378:windows:placeholder",
    messagingSenderId: "1020726856378",
    projectId: "pee-ka-boo-play-house",
    storageBucket: "pee-ka-boo-play-house.firebasestorage.app",
  );
}