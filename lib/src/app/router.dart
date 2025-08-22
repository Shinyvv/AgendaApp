import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/role_selection_screen.dart';
import '../../features/dashboard/main_dashboard.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoginPage = state.matchedLocation == '/login';

      // Si no está autenticado, ir al login
      if (!isLoggedIn && !isLoginPage) {
        return '/login';
      }

      // Si está autenticado pero en login, ir al dashboard
      if (isLoggedIn && isLoginPage) {
        return '/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainDashboard(),
      ),
    ],
  );
});
