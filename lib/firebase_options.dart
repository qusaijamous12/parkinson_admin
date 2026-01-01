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
    apiKey: 'AIzaSyB_zP2P9_yz4HqGIFaZO45nZUikeu2UVcY',
    authDomain: 'parkinson-c9f06.firebaseapp.com',
    projectId: 'parkinson-c9f06',
    storageBucket: 'parkinson-c9f06.firebasestorage.app',
    messagingSenderId: '881949411565',
    appId: '1:881949411565:web:3e8f1a5612ba24073ae4e4',
      measurementId: 'G-FECQVR6DC4'
  );
}