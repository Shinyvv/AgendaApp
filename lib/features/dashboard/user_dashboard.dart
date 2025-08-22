import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/services/user_service.dart';
import '../../src/models/user_model.dart';
import '../auth/auth_service.dart';
import 'role_switcher.dart';

/// Pantalla principal del usuario (cliente)
class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);
    final workers = ref.watch(allWorkersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Agenda'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          const RoleSwitcher(),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileMenu(context, ref),
          ),
        ],
      ),
      body: currentUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No hay usuario logueado'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(allWorkersProvider.future),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saludo personalizado
                  _WelcomeCard(user: user),
                  const SizedBox(height: 20),

                  // Acciones rápidas
                  _QuickActions(),
                  const SizedBox(height: 20),

                  // Lista de trabajadores disponibles
                  Text(
                    'Trabajadores Disponibles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  workers.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Text('Error cargando trabajadores: $error'),
                    data: (workersList) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workersList.length,
                      itemBuilder: (context, index) {
                        final worker = workersList[index];
                        return _WorkerCard(worker: worker);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewBooking(context, ref),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
      ),
    );
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ProfileMenu(),
    );
  }

  void _createNewBooking(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de crear cita próximamente disponible'),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final AppUser user;

  const _WelcomeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? Text(
                      user.displayName?.substring(0, 1).toUpperCase() ??
                          user.email.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, ${user.displayName ?? 'Usuario'}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '¿Qué servicio necesitas hoy?',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.green, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.calendar_today,
                  label: 'Mis Citas',
                  color: Colors.blue,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.history,
                  label: 'Historial',
                  color: Colors.purple,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.star,
                  label: 'Favoritos',
                  color: Colors.orange,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final AppUser worker;

  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: worker.photoURL != null
              ? NetworkImage(worker.photoURL!)
              : null,
          child: worker.photoURL == null
              ? Icon(Icons.person, color: Colors.grey.shade600)
              : null,
        ),
        title: Text(
          worker.displayName ?? 'Trabajador',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (worker.specialties != null) ...[
              const SizedBox(height: 4),
              Text(
                'Especialidades: ${worker.specialties}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                if (worker.rating != null) ...[
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${worker.rating?.toStringAsFixed(1)} • '),
                ],
                Text('${worker.completedJobs ?? 0} trabajos'),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _contactWorker(context, worker),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Contactar'),
        ),
      ),
    );
  }

  void _contactWorker(BuildContext context, AppUser worker) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contactando a ${worker.displayName}...')),
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Cambiar a Trabajador'),
            onTap: () => _switchToWorker(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _signOut(context, ref),
          ),
        ],
      ),
    );
  }

  void _switchToWorker(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/role-selection');
  }

  void _signOut(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    await ref.read(authServiceProvider).signOut();
  }
}
