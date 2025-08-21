import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/booking/presentation/screens/booking_home_screen.dart';
import '../features/employee/presentation/screens/employee_schedule_screen.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuth = authState.valueOrNull != null;
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) {
        return null; // Let splash screen handle its own logic
      }

      if (!isAuth && state.matchedLocation != '/login') {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingHomeScreen(),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const EmployeeScheduleScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
