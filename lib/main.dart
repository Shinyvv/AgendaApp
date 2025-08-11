import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/auth/google_sign_in_button.dart';
import 'features/booking/presentation/booking_calendar.dart';
import 'features/notifications/local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // Do not await Firebase/notifications here to avoid blocking app start on errors.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashPage()),
        GoRoute(path: '/booking', builder: (_, __) => const BookingHomePage()),
        GoRoute(
          path: '/schedule',
          builder: (_, __) => const EmployeeSchedulePage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const AdminDashboardPage(),
        ),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/reset', builder: (_, __) => const ResetPasswordPage()),
      ],
    );

    return MaterialApp.router(
      title: 'SaaS Appointments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: router,
    );
  }
}

enum AppRole { admin, employee, client }

AppRole? roleFromClaims(Map<String, dynamic>? claims) {
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

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
      final role = roleFromClaims(token.claims);
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;

  Future<void> _signIn() async {
    setState(() => error = null);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );
      await cred.user?.getIdToken(true);
      if (!mounted) return;
      context.go('/');
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _signIn, child: const Text('Sign in')),
            const SizedBox(height: 8),
            const GoogleSignInButton(),
            TextButton(
              onPressed: () => context.push('/reset'),
              child: const Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailCtrl = TextEditingController();
  String? info;
  Future<void> _reset() async {
    setState(() => info = null);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCtrl.text.trim(),
      );
      setState(() => info = 'Email sent');
    } catch (e) {
      setState(() => info = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _reset,
              child: const Text('Send reset email'),
            ),
            if (info != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(info!),
              ),
          ],
        ),
      ),
    );
  }
}

class BookingHomePage extends StatelessWidget {
  const BookingHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book an appointment')),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: BookingCalendar(),
      ),
    );
  }
}

class EmployeeSchedulePage extends StatelessWidget {
  const EmployeeSchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Employee Schedule')));
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int? todaysAppointments;
  num? todaysRevenueCents;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      error = null;
      todaysAppointments = null;
      todaysRevenueCents = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not signed in');
      final token = await user.getIdTokenResult();
      final bizId = token.claims?['businessId'] as String?;
      if (bizId == null) throw Exception('No businessId claim');

      final now = DateTime.now();
      final start = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
      final end = Timestamp.fromDate(
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      );

      final agg = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(bizId)
          .collection('appointments')
          .where('startAt', isGreaterThanOrEqualTo: start)
          .where('startAt', isLessThan: end)
          .count()
          .get();

      final metricsDoc = await FirebaseFirestore.instance
          .doc(
            'businesses/$bizId/metrics_daily/${DateTime(now.year, now.month, now.day).toIso8601String().substring(0, 10)}',
          )
          .get();

      setState(() {
        todaysAppointments = agg.count;
        todaysRevenueCents = (metricsDoc.data()?['revenueCents'] as num?) ?? 0;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            Text('Today\'s appointments: ${todaysAppointments ?? '...'}'),
            Text(
              'Today\'s revenue: ${todaysRevenueCents != null ? (todaysRevenueCents! / 100).toStringAsFixed(2) : '...'}',
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
