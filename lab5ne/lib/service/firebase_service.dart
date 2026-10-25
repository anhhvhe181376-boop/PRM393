import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirebaseService {
  // Không cần tạo đối tượng của lớp này.
  FirebaseService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}