import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/enhanced_login_screen.dart';
import '../../features/auth/presentation/enhanced_register_screen.dart';
import '../../features/dashboard/presentation/enhanced_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/main_dashboard.dart';
import '../../features/dashboard/presentation/screens/user_dashboard.dart';
import '../../features/dashboard/presentation/screens/worker_dashboard.dart';
import '../../examples/ui_components_examples.dart';

/// Configuración de rutas de la aplicación usando GoRouter
///
/// Este archivo centraliza toda la configuración de navegación
/// y maneja la protección de rutas basada en autenticación.
class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppConstants.initialRoute,
      redirect: (context, state) {
        final authState = ref.watch(authProvider);
        final isLoggedIn = authState.asData?.value != null;
        final currentPath = state.matchedLocation;

        // Rutas públicas que no requieren autenticación
        final publicRoutes = [AppConstants.loginRoute, '/register'];

        // Si no está logueado y no está en ruta pública, redirigir a login
        if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
          return AppConstants.loginRoute;
        }

        // Si está logueado y está en login o register, redirigir al dashboard
        if (isLoggedIn && publicRoutes.contains(currentPath)) {
          return AppConstants.dashboardRoute;
        }

        return null; // No redireccionar
      },
      routes: [
        GoRoute(
          path: AppConstants.initialRoute,
          redirect: (context, state) => AppConstants.dashboardRoute,
        ),
        GoRoute(
          path: AppConstants.loginRoute,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const EnhancedLoginScreen(),
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const EnhancedRegisterScreen(),
          ),
        ),
        GoRoute(
          path: AppConstants.dashboardRoute,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const EnhancedDashboardScreen(),
          ),
          routes: [
            GoRoute(
              path: 'user',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const UserDashboard(),
              ),
            ),
            GoRoute(
              path: 'worker',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const WorkerDashboard(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/ui-examples',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const UIComponentsExamples(),
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Página no encontrada',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'La ruta "${state.matchedLocation}" no existe.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.dashboardRoute),
                child: const Text('Ir al Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
