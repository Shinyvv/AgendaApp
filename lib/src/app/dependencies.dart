import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../firebase_options.dart';
import '../features/notifications/local_notifications.dart';

/// Provider for the Firebase initialization future.
final firebaseInitializationProvider = FutureProvider<FirebaseApp>((ref) async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize timezone data
  tz.initializeTimeZones();
  // Initialize local notifications (but not on web)
  if (!kIsWeb) {
    await LocalNotifications.init();
  }
  return app;
});
