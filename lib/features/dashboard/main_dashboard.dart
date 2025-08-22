import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/services/user_service.dart';
import '../../src/models/user_model.dart';
import 'user_dashboard.dart';
import 'worker_dashboard.dart';
import '../auth/role_selection_screen.dart';
import '../auth/auth_service.dart';

/// Pantalla principal que redirige según el rol del usuario
class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);

    return currentUser.when(
      loading: () {
        print('MainDashboard: Cargando usuario...');
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando tu perfil...'),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        print('MainDashboard: Error al cargar usuario: $error');
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar el perfil',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.refresh(currentAppUserProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      },
      data: (user) {
        print('MainDashboard: Usuario cargado: $user');
        if (user == null) {
          print('MainDashboard: Usuario es null, mostrando selección de rol');

          // Si el usuario está autenticado en Firebase pero no existe en Firestore,
          // crear el usuario automáticamente y mostrar selección de rol
          final firebaseUser = ref.read(authServiceProvider).currentUser;
          if (firebaseUser != null) {
            print(
              'MainDashboard: Usuario autenticado en Firebase pero sin documento en Firestore',
            );
            // Crear el usuario en Firestore en background
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                final userService = ref.read(userServiceProvider);
                await userService.createUserFromFirebaseAuth(firebaseUser);
                print(
                  'MainDashboard: Usuario creado en Firestore automáticamente',
                );
              } catch (e) {
                print(
                  'MainDashboard: Error al crear usuario automáticamente: $e',
                );
              }
            });
          }

          // Usuario no existe en Firestore, redirigir a selección de rol
          return const RoleSelectionScreen();
        }

        print('MainDashboard: Redirigiendo según rol: ${user.role}');
        // Redirigir según el rol
        switch (user.role) {
          case UserRole.usuario:
            return const UserDashboard();
          case UserRole.trabajador:
            return const WorkerDashboard();
        }
      },
    );
  }
}

/// Widget helper para mostrar estado de carga personalizado
class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({super.key, this.message = 'Cargando...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget helper para mostrar errores
class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
