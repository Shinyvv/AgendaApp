import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/services/user_service.dart';
import '../../src/models/user_model.dart';

/// Widget para cambiar el rol del usuario
class RoleSwitcher extends ConsumerWidget {
  const RoleSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);
    final userService = ref.read(userServiceProvider);

    return currentUser.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return PopupMenuButton<UserRole>(
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'Cambiar rol',
          onSelected: (UserRole newRole) async {
            if (newRole == user.role) return;

            try {
              await userService.changeUserRole(user.uid, newRole);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Rol cambiado a ${newRole == UserRole.usuario ? 'Usuario' : 'Trabajador'}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cambiar rol: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: UserRole.usuario,
              enabled: user.role != UserRole.usuario,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: user.role == UserRole.usuario ? Colors.blue : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Usuario (Cliente)',
                    style: TextStyle(
                      fontWeight: user.role == UserRole.usuario
                          ? FontWeight.bold
                          : null,
                      color: user.role == UserRole.usuario ? Colors.blue : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: UserRole.trabajador,
              enabled: user.role != UserRole.trabajador,
              child: Row(
                children: [
                  Icon(
                    Icons.work,
                    color: user.role == UserRole.trabajador
                        ? Colors.orange
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Trabajador',
                    style: TextStyle(
                      fontWeight: user.role == UserRole.trabajador
                          ? FontWeight.bold
                          : null,
                      color: user.role == UserRole.trabajador
                          ? Colors.orange
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Widget para mostrar el rol actual del usuario
class CurrentRoleIndicator extends ConsumerWidget {
  const CurrentRoleIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);

    return currentUser.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final isWorker = user.role == UserRole.trabajador;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isWorker ? Colors.orange.shade100 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isWorker ? Colors.orange.shade300 : Colors.blue.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWorker ? Icons.work : Icons.person,
                size: 16,
                color: isWorker ? Colors.orange.shade700 : Colors.blue.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                isWorker ? 'Trabajador' : 'Cliente',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isWorker
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
