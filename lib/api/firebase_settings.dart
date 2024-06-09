import 'package:firebase_core/firebase_core.dart';

class MyFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "***REMOVED***",
      authDomain: "studyguide_flutter.firebaseapp.com",
      projectId: "studyguide-flutter",
      storageBucket: "studyguide-flutter.appspot.com",
      messagingSenderId: "***REMOVED***",
      appId: "1:***REMOVED***:android:175fdc53de309828828763",
    );
  }
}
