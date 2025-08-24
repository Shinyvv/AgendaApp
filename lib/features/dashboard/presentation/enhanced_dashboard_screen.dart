/// Dashboard principal mejorado con principios UX/UI
///
/// Implementa jerarquía visual, gamificación, CTAs efectivos,
/// y micro-interacciones para mejor experiencia de usuario.
library;

import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/app_design_system.dart';
import '../../../core/widgets/enhanced_ui_components.dart' as ui;
import '../../../core/providers/auth_provider.dart';

class EnhancedDashboardScreen extends ConsumerStatefulWidget {
  const EnhancedDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState
    extends ConsumerState<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _cardsSlideAnimation;

  // Estados para gamificación
  double _profileCompletion = 0.0;
  int _notificationCount = 3;
  Map<String, dynamic> _quickStats = {};

  @override
  void initState() {
    super.initState();

    // Configurar animaciones de entrada
    _headerAnimationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: AppAnimations.fadeIn,
      ),
    );

    _cardsSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _cardsAnimationController,
            curve: AppAnimations.smooth,
          ),
        );

    // Iniciar animaciones con delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _headerAnimationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _cardsAnimationController.forward();
    });

    // Simular carga de datos
    _loadUserData();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardsAnimationController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Simular datos del usuario para gamificación
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _profileCompletion = 0.75; // 75% completado
          _quickStats = {
            'servicios_activos': 12,
            'servicios_completados': 45,
            'calificacion_promedio': 4.8,
            'ingresos_mes': 1250.0,
          };
        });
      }
    });
  }

  Future<void> _refreshData() async {
    // Simular refresh de datos
    await Future.delayed(const Duration(seconds: 2));
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.asData?.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App bar personalizado con gradiente
            _buildCustomSliverAppBar(user),

            // Contenido principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    // Progreso del perfil (gamificación)
                    _buildProfileProgress(),

                    const SizedBox(height: AppSpacing.lg),

                    // Estadísticas rápidas
                    _buildQuickStats(),

                    const SizedBox(height: AppSpacing.lg),

                    // Acciones rápidas con CTAs efectivos
                    _buildQuickActions(),

                    const SizedBox(height: AppSpacing.lg),

                    // Servicios recientes
                    _buildRecentServices(),

                    const SizedBox(height: AppSpacing.lg),

                    // CTAs promocionales
                    _buildPromotionalCTAs(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // FAB con menú de opciones
      floatingActionButton: _buildAnimatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCustomSliverAppBar(dynamic user) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: FlexibleSpaceBar(
          background: FadeTransition(
            opacity: _headerAnimation,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Para el status bar
                  // Saludo personalizado (retención de atención)
                  Text(
                    _getGreeting(user?.displayName?.toString()),
                    style: AppTypography.h2.copyWith(color: Colors.white),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Tienes ${_notificationCount > 0 ? '$_notificationCount nuevas notificaciones' : 'todo al día'}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Indicadores de estado
                  _buildStatusIndicators(),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        // Notificaciones con badge
        ui.NotificationBadge(
          count: _notificationCount,
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Navegar a notificaciones
            },
          ),
        ),

        // Menú de usuario
        IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              user?.displayName?.toString().substring(0, 1).toUpperCase() ??
                  'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            // Mostrar menú de perfil
          },
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  String _getGreeting(String? name) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    return name != null ? '$greeting, $name' : '$greeting!';
  }

  Widget _buildStatusIndicators() {
    return Row(
      children: [
        _buildStatusChip(
          'En línea',
          AppColors.success,
          Icons.online_prediction,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildStatusChip('Disponible', AppColors.warning, Icons.work_outline),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: AppBorders.pill,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileProgress() {
    return SlideTransition(
      position: _cardsSlideAnimation,
      child: ui.EnhancedCard(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: AppIcons.medium,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Completa tu perfil', style: AppTypography.h3),
                const Spacer(),
                Text(
                  'Nivel Pro',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Barra de progreso con gamificación
            ui.ProgressIndicator(
              value: _profileCompletion,
              label: 'Progreso del perfil',
              progressColor: AppColors.success,
              showPercentage: true,
              animated: true,
            ),

            const SizedBox(height: AppSpacing.md),

            // Beneficios de completar perfil
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Completa tu perfil para obtener más trabajos y mejorar tu visibilidad',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ui.SecondaryCTAButton(
                  text: 'Completar',
                  onPressed: () {
                    // Navegar a completar perfil
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SlideTransition(
      position: _cardsSlideAnimation,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Servicios Activos',
              '${_quickStats['servicios_activos'] ?? 0}',
              Icons.work_outline,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildStatCard(
              'Completados',
              '${_quickStats['servicios_completados'] ?? 0}',
              Icons.check_circle_outline,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return ui.EnhancedCard(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppIcons.large),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Nuevo Servicio',
        'subtitle': 'Crear oferta de trabajo',
        'icon': Icons.add_business,
        'color': AppColors.primary,
        'urgency': '¡Gana más dinero!',
      },
      {
        'title': 'Buscar Trabajo',
        'subtitle': 'Explorar oportunidades',
        'icon': Icons.search,
        'color': AppColors.secondary,
        'urgency': 'Trabajos disponibles',
      },
      {
        'title': 'Mi Calendario',
        'subtitle': 'Gestionar horarios',
        'icon': Icons.calendar_today,
        'color': AppColors.warning,
        'urgency': '3 citas hoy',
      },
      {
        'title': 'Mensajes',
        'subtitle': 'Comunicarse con clientes',
        'icon': Icons.chat_bubble_outline,
        'color': AppColors.info,
        'urgency': '2 mensajes nuevos',
      },
    ];

    return SlideTransition(
      position: _cardsSlideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acciones Rápidas', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(action);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return ui.EnhancedCard(
      backgroundColor: Colors.white,
      onTap: () {
        // Navegar según la acción
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (action['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              action['icon'] as IconData,
              color: action['color'] as Color,
              size: AppIcons.large,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            action['title'] as String,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            action['subtitle'] as String,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // Badge de urgencia para retención de atención
          if (action['urgency'] != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: AppBorders.small,
              ),
              child: Text(
                action['urgency'] as String,
                style: AppTypography.caption.copyWith(
                  color: AppColors.error,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentServices() {
    return SlideTransition(
      position: _cardsSlideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Servicios Recientes', style: AppTypography.h3),
              TextButton(
                onPressed: () {
                  // Navegar a todos los servicios
                },
                child: Text(
                  'Ver todos',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Lista de servicios simulados
          ...List.generate(3, (index) => _buildServiceCard(index)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(int index) {
    final services = [
      {
        'title': 'Reparación de plomería',
        'client': 'María González',
        'status': 'En progreso',
        'amount': '\$150',
        'date': 'Hoy, 2:00 PM',
        'color': AppColors.warning,
      },
      {
        'title': 'Limpieza de casa',
        'client': 'Carlos Ruiz',
        'status': 'Completado',
        'amount': '\$80',
        'date': 'Ayer, 10:00 AM',
        'color': AppColors.success,
      },
      {
        'title': 'Jardinería',
        'client': 'Ana Torres',
        'status': 'Pendiente',
        'amount': '\$120',
        'date': 'Mañana, 9:00 AM',
        'color': AppColors.info,
      },
    ];

    final service = services[index];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ui.EnhancedCard(
        backgroundColor: Colors.white,
        onTap: () {
          // Navegar a detalles del servicio
        },
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: service['color'] as Color,
                borderRadius: AppBorders.small,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['title'] as String,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Cliente: ${service['client']}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    service['date'] as String,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  service['amount'] as String,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (service['color'] as Color).withOpacity(0.1),
                    borderRadius: AppBorders.small,
                  ),
                  child: Text(
                    service['status'] as String,
                    style: AppTypography.caption.copyWith(
                      color: service['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionalCTAs() {
    return Column(
      children: [
        // CTA promocional con urgencia
        ui.EnhancedCard(
          backgroundColor: AppColors.primary,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Aumenta tus ingresos!',
                      style: AppTypography.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Completa tu perfil y obtén hasta 3x más trabajos',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ui.PrimaryCTAButton(
                      text: 'Completar ahora',
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      onPressed: () {
                        // Navegar a completar perfil
                      },
                    ),
                  ],
                ),
              ),
              const Icon(Icons.trending_up, size: 60, color: Colors.white24),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // CTA secundario con beneficios
        ui.EnhancedCard(
          backgroundColor: AppColors.surfaceVariant,
          child: Column(
            children: [
              Text(
                'Invita a un amigo y gana \$50',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Por cada amigo que se registre usando tu código',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ui.SecondaryCTAButton(
                text: 'Compartir código',
                icon: Icons.share,
                onPressed: () {
                  // Compartir código de referido
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navegar a ejemplos de UI/UX para demostrar componentes
        context.go('/ui-examples');
      },
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.design_services),
      label: const Text('Ver Ejemplos UI'),
    );
  }
}
