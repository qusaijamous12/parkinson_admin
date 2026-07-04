import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('This config only supports web');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCbqFAyEM1CNmZnZ8n1yAystVzCES6F_A4',
    authDomain: 'parkinson-new.firebaseapp.com',
    projectId: 'parkinson-new',
    storageBucket: 'parkinson-new.firebasestorage.app',
    messagingSenderId: '855772019150',
    appId: '1:855772019150:web:326c6415f806187208539f',
      measurementId: 'G-Z6WQ4XV2T6'
  );
}