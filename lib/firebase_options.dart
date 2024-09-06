// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSyDmCjNyECojRlxOFMbpDHUIyK7JRtfFC8g',
      appId: '1:604852875090:web:a8394b17be2e944bd3948b',
      messagingSenderId: '604852875090',
      projectId: 'ticketmanager-31154',
      authDomain: 'ticketmanager-31154.firebaseapp.com',
      storageBucket: 'ticketmanager-31154.appspot.com',
      // autres options spécifiques au Web, Android, iOS...
    );
  }
}
