import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

import '../../../../../firebase_options.dart';
import '../../../notifications/local_notifications.dart';
import '../providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (!kIsWeb) {
        // flutter_local_notifications has limited/no web support
        await LocalNotifications.init();
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) context.go('/login');
        return;
      }

      await user.getIdToken(true);
      final token = await user.getIdTokenResult();
      final role = _roleFromClaims(token.claims);

      if (!mounted) return;

      if (role == AppRole.admin) {
        context.go('/dashboard');
      } else if (role == AppRole.employee) {
        context.go('/schedule');
      } else {
        context.go('/booking');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  AppRole? _roleFromClaims(Map<String, dynamic>? claims) {
    final r = claims?['role'] as String?;
    switch (r) {
      case 'admin':
        return AppRole.admin;
      case 'employee':
        return AppRole.employee;
      case 'client':
        return AppRole.client;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Initialization failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _bootstrap,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
