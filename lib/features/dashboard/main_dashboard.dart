import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../src/services/user_service.dart';
import '../../src/models/user_model.dart';
import 'user_dashboard.dart';
import 'worker_dashboard.dart';
import '../auth/role_selection_screen.dart';

/// Pantalla principal que redirige según el rol del usuario
class MainDashboard extends ConsumerWidget {
  const MainDashboard({super.key});

  /// Helper para logging condicional solo en debug
  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('📱 MainDashboard: $message');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _debugLog('=== BUILD INICIADO ===');
    final currentUser = ref.watch(currentAppUserProvider);
    _debugLog('Provider estado: ${currentUser.runtimeType}');

    return currentUser.when(
      loading: () {
        _debugLog('Estado LOADING - Mostrando spinner');
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
        _debugLog('Estado ERROR: $error');
        _debugLog('Stack trace: $stackTrace');
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
                  onPressed: () {
                    _debugLog('Usuario presionó Reintentar');
                    // Invalidar el provider para forzar recarga
                    ref.invalidate(currentAppUserProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recargando perfil...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      },
      data: (user) {
        _debugLog('=== ESTADO DATA ===');
        _debugLog('Usuario recibido: $user');
        _debugLog('Usuario es null: ${user == null}');

        if (user == null) {
          _debugLog('Usuario es null -> Mostrando RoleSelectionScreen');
          // Usuario no existe en Firestore, mostrar selección de rol
          return const RoleSelectionScreen();
        }

        _debugLog('Usuario válido encontrado');
        _debugLog('UID: ${user.uid}');
        _debugLog('Email: ${user.email}');
        _debugLog('Rol: ${user.role}');
        _debugLog('🚀 Redirigiendo según rol: ${user.role}');

        // Redirigir según el rol
        switch (user.role) {
          case UserRole.usuario:
            _debugLog('👤 Navegando a UserDashboard');
            return const UserDashboard();
          case UserRole.trabajador:
            _debugLog('🔧 Navegando a WorkerDashboard');
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
