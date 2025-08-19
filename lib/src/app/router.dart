import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_service.dart';
import '../../features/auth/login_screen.dart';
import '../features/booking/presentation/screens/booking_home_screen.dart';
import '../features/employee/presentation/screens/employee_schedule_screen.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = authState.valueOrNull;
      final isAuth = user != null;
      final isLoginRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      // Si no está autenticado y no está en login/signup, redirigir a login
      if (!isAuth && !isLoginRoute) {
        return '/login';
      }

      // Si está autenticado y está en login/signup, redirigir a home
      if (isAuth && isLoginRoute) {
        return '/booking';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
