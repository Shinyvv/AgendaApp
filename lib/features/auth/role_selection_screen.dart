import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../src/models/user_model.dart';
import '../../src/services/user_service.dart';
import '../auth/auth_service.dart';

/// Pantalla para seleccionar el rol del usuario después del registro
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole? selectedRole;
  bool isLoading = false;

  Future<void> _selectRole(UserRole role) async {
    if (isLoading) return;

    print('Seleccionando rol: $role');
    setState(() {
      selectedRole = role;
      isLoading = true;
    });

    try {
      final user = ref.read(authServiceProvider).currentUser;
      print('Usuario actual: ${user?.uid}');
      if (user != null) {
        final userService = ref.read(userServiceProvider);
        print('Cambiando rol a: ${role.name}');
        await userService.changeUserRole(user.uid, role);
        print('Rol cambiado exitosamente');

        // Navegar a la pantalla principal según el rol
        if (mounted) {
          print('Navegando a dashboard');
          context.go('/dashboard');
        }
      } else {
        print('Error: Usuario no encontrado');
      }
    } catch (e) {
      print('Error al seleccionar rol: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar rol: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu rol'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Cómo quieres usar la aplicación?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Opción Usuario
            _RoleCard(
              role: UserRole.usuario,
              title: UserRole.usuario.displayName,
              description: UserRole.usuario.description,
              icon: Icons.person,
              color: Colors.green,
              isSelected: selectedRole == UserRole.usuario,
              isLoading: isLoading && selectedRole == UserRole.usuario,
              onTap: () => _selectRole(UserRole.usuario),
            ),

            const SizedBox(height: 20),

            // Opción Trabajador
            _RoleCard(
              role: UserRole.trabajador,
              title: UserRole.trabajador.displayName,
              description: UserRole.trabajador.description,
              icon: Icons.work,
              color: Colors.orange,
              isSelected: selectedRole == UserRole.trabajador,
              isLoading: isLoading && selectedRole == UserRole.trabajador,
              onTap: () => _selectRole(UserRole.trabajador),
            ),

            const SizedBox(height: 40),
            const Text(
              'Podrás cambiar esto más tarde en la configuración',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),

              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Loading o check
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isSelected)
                Icon(Icons.check_circle, color: color, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
