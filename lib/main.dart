import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue anyway to show error in app
  }

  // Connect to Firebase emulators if in debug mode
  // DISABLED FOR DEVICE TESTING - Use production Firebase
  // if (kDebugMode) {
  //   try {
  //     // Use PC IP address for device testing
  //     FirebaseAuth.instance.useAuthEmulator('192.168.1.9', 9099);
  //     FirebaseFirestore.instance.useFirestoreEmulator('192.168.1.9', 8081);
  //     print('Connected to Firebase emulators at 192.168.1.9');
  //   } catch (e) {
  //     print('Error connecting to emulators: $e');
  //   }
  // }

  runApp(const ProviderScope(child: MyApp()));
}
