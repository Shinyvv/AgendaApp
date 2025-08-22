import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/services/user_service.dart';
import '../../src/models/user_model.dart';

/// Widget de demostración para mostrar el sistema de permisos
class PermissionDemo extends ConsumerWidget {
  const PermissionDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo de Permisos'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: currentUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Usuario no encontrado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(user),
                const SizedBox(height: 24),
                _buildPermissionsSection(user, ref),
                const SizedBox(height: 24),
                _buildActionsSection(user, ref),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(AppUser user) {
    final isWorker = user.role == UserRole.trabajador;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isWorker ? Colors.orange : Colors.blue,
                  child: Icon(
                    isWorker ? Icons.work : Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isWorker ? Colors.orange.shade100 : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Rol: ${isWorker ? 'TRABAJADOR' : 'USUARIO (Cliente)'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isWorker
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection(AppUser user, WidgetRef ref) {
    final allPermissions = [
      'create_booking',
      'view_own_bookings',
      'cancel_booking',
      'rate_service',
      'view_workers',
      'view_all_bookings',
      'accept_booking',
      'reject_booking',
      'complete_booking',
      'view_earnings',
      'manage_schedule',
      'view_client_info',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛡️ Permisos del Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...allPermissions.map((permission) {
              final hasPermission = user.role.permissions.contains(permission);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      hasPermission ? Icons.check_circle : Icons.cancel,
                      color: hasPermission ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getPermissionDescription(permission),
                        style: TextStyle(
                          color: hasPermission
                              ? Colors.black87
                              : Colors.grey.shade600,
                          decoration: hasPermission
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(AppUser user, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚡ Acciones Disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (user.role == UserRole.usuario) ...[
              _buildActionTile(
                'Crear Nueva Reserva',
                Icons.add_circle,
                Colors.green,
                true,
              ),
              _buildActionTile(
                'Ver Mis Reservas',
                Icons.list_alt,
                Colors.blue,
                true,
              ),
              _buildActionTile(
                'Buscar Trabajadores',
                Icons.search,
                Colors.purple,
                true,
              ),
              _buildActionTile(
                'Gestionar Horarios',
                Icons.schedule,
                Colors.grey,
                false,
              ),
            ] else ...[
              _buildActionTile(
                'Ver Todas las Reservas',
                Icons.calendar_view_day,
                Colors.orange,
                true,
              ),
              _buildActionTile(
                'Gestionar Horarios',
                Icons.schedule,
                Colors.green,
                true,
              ),
              _buildActionTile(
                'Ver Ganancias',
                Icons.monetization_on,
                Colors.blue,
                true,
              ),
              _buildActionTile(
                'Crear Reservas',
                Icons.add_circle,
                Colors.grey,
                false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    Color color,
    bool enabled,
  ) {
    return ListTile(
      leading: Icon(icon, color: enabled ? color : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.grey.shade600,
          decoration: enabled ? null : TextDecoration.lineThrough,
        ),
      ),
      trailing: Icon(
        enabled ? Icons.arrow_forward_ios : Icons.block,
        color: enabled ? color : Colors.grey,
        size: 16,
      ),
      enabled: enabled,
      onTap: enabled
          ? () {
              // Aquí irían las acciones reales
            }
          : null,
    );
  }

  String _getPermissionDescription(String permission) {
    switch (permission) {
      case 'create_booking':
        return 'Crear nuevas reservas';
      case 'view_own_bookings':
        return 'Ver mis propias reservas';
      case 'cancel_booking':
        return 'Cancelar reservas';
      case 'rate_service':
        return 'Calificar servicios';
      case 'view_workers':
        return 'Ver lista de trabajadores';
      case 'view_all_bookings':
        return 'Ver todas las reservas';
      case 'accept_booking':
        return 'Aceptar reservas';
      case 'reject_booking':
        return 'Rechazar reservas';
      case 'complete_booking':
        return 'Completar trabajos';
      case 'view_earnings':
        return 'Ver ganancias';
      case 'manage_schedule':
        return 'Gestionar horarios';
      case 'view_client_info':
        return 'Ver información de clientes';
      default:
        return permission;
    }
  }
}
