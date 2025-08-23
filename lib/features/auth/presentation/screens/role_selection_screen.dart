import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/user_service.dart';

/// Pantalla de selección de rol para nuevos usuarios
///
/// Esta pantalla se muestra cuando un usuario se registra por primera vez
/// y necesita seleccionar su rol (usuario o trabajador).
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  bool _isLoading = false;
  String? _selectedRole;

  Future<void> _saveRole() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un rol'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userService = ref.read(userServiceProvider);
      await userService.createUserProfile(_selectedRole!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Perfil creado exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu rol'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Para completar tu registro, selecciona tu rol en la aplicación:',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Opción Usuario
            Card(
              child: RadioListTile<String>(
                title: const Text('Usuario'),
                subtitle: const Text('Buscar y reservar servicios'),
                value: AppConstants.userRole,
                groupValue: _selectedRole,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() => _selectedRole = value);
                      },
                secondary: const Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            // Opción Trabajador
            Card(
              child: RadioListTile<String>(
                title: const Text('Trabajador'),
                subtitle: const Text('Ofrecer servicios profesionales'),
                value: AppConstants.workerRole,
                groupValue: _selectedRole,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() => _selectedRole = value);
                      },
                secondary: const Icon(Icons.work),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveRole,
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Creando perfil...'),
                        ],
                      )
                    : const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
