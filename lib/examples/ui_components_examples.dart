/// Ejemplos de uso de los componentes UI mejorados
///
/// Este archivo muestra cómo implementar los nuevos componentes
/// con principios UX/UI en diferentes contextos de la aplicación.
library;

import 'package:flutter/material.dart';
import '../core/design/app_design_system.dart';
import '../core/widgets/enhanced_ui_components.dart' as ui;

/// Ejemplos prácticos de uso de componentes UX/UI mejorados
class UIComponentsExamples extends StatefulWidget {
  const UIComponentsExamples({Key? key}) : super(key: key);

  @override
  State<UIComponentsExamples> createState() => _UIComponentsExamplesState();
}

class _UIComponentsExamplesState extends State<UIComponentsExamples> {
  bool _isLoading = false;
  double _progress = 0.0;
  int _notificationCount = 5;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Componentes UX/UI Mejorados')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: CTAs Efectivos
            _buildSectionTitle('CTAs Efectivos'),
            _buildCTAExamples(),

            const SizedBox(height: AppSpacing.xl),

            // Sección: Micro-interacciones
            _buildSectionTitle('Cards con Micro-interacciones'),
            _buildCardExamples(),

            const SizedBox(height: AppSpacing.xl),

            // Sección: Gamificación
            _buildSectionTitle('Gamificación y Progreso'),
            _buildProgressExamples(),

            const SizedBox(height: AppSpacing.xl),

            // Sección: Formularios Mejorados
            _buildSectionTitle('Formularios con Validación Visual'),
            _buildFormExamples(),

            const SizedBox(height: AppSpacing.xl),

            // Sección: Notificaciones
            _buildSectionTitle('Notificaciones y Badges'),
            _buildNotificationExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(title, style: AppTypography.h2),
    );
  }

  Widget _buildCTAExamples() {
    return Column(
      children: [
        // CTA Primario con gradiente y micro-animación
        ui.PrimaryCTAButton(
          text: '¡Sí, quiero aumentar mis ingresos!',
          icon: Icons.trending_up,
          isLoading: _isLoading,
          fullWidth: true,
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isLoading = false;
              });
            });
          },
        ),

        const SizedBox(height: AppSpacing.md),

        // CTA de urgencia con color de acción
        ui.PrimaryCTAButton(
          text: 'Oferta limitada - Solo hoy',
          icon: Icons.access_time,
          backgroundColor: AppColors.action,
          fullWidth: true,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('¡Aprovechaste la oferta especial!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),

        const SizedBox(height: AppSpacing.md),

        // CTA secundario para opciones alternativas
        Row(
          children: [
            Expanded(
              child: ui.SecondaryCTAButton(
                text: 'Más información',
                icon: Icons.info_outline,
                onPressed: () {
                  _showInfoDialog();
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ui.SecondaryCTAButton(
                text: 'Contactar soporte',
                icon: Icons.support_agent,
                onPressed: () {
                  // Acción de contacto
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardExamples() {
    return Column(
      children: [
        // Card con hover effect y contenido rico
        ui.EnhancedCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Card tocado - Micro-interacción activada'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppBorders.small,
                    ),
                    child: const Icon(
                      Icons.work,
                      color: AppColors.primary,
                      size: AppIcons.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Servicio Destacado',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Plomería profesional - Disponible ahora',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: AppBorders.pill,
                    ),
                    child: Text(
                      '\$150/hora',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Toca para ver el hover effect y la elevación animada. '
                'Esta card responde con micro-interacciones para confirmar la acción.',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Grid de cards estadísticas
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Trabajos\nCompletados',
                '45',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                'Calificación\nPromedio',
                '4.8⭐',
                Icons.star,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return ui.EnhancedCard(
      backgroundColor: color.withOpacity(0.05),
      onTap: () {
        // Animación de feedback
      },
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
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressExamples() {
    return Column(
      children: [
        // Progreso del perfil con gamificación
        ui.EnhancedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: AppIcons.medium,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Completa tu perfil',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: AppBorders.small,
                    ),
                    child: Text(
                      'Nivel Pro',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ui.ProgressIndicator(
                value: _progress,
                label: 'Progreso del perfil',
                progressColor: AppColors.success,
                showPercentage: true,
                animated: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Completa tu perfil para obtener hasta 3x más trabajos',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ui.SecondaryCTAButton(
                    text: _progress >= 1.0 ? '¡Completado!' : 'Completar',
                    onPressed: _progress >= 1.0
                        ? null
                        : () {
                            setState(() {
                              _progress += 0.25;
                              if (_progress > 1.0) _progress = 1.0;
                            });
                          },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Botón para resetear progreso
        TextButton(
          onPressed: () {
            setState(() {
              _progress = 0.0;
            });
          },
          child: const Text('Resetear progreso'),
        ),
      ],
    );
  }

  Widget _buildFormExamples() {
    return Column(
      children: [
        // Campo de email con validación visual
        ui.EnhancedTextField(
          label: 'Email profesional',
          hint: 'tu@empresa.com',
          controller: _textController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El email es requerido';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Formato de email inválido';
            }
            return null;
          },
        ),

        const SizedBox(height: AppSpacing.md),

        // Campo de contraseña con toggle de visibilidad
        ui.EnhancedTextField(
          label: 'Contraseña segura',
          hint: 'Mínimo 8 caracteres',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              // Toggle password visibility
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La contraseña es requerida';
            }
            if (value.length < 8) {
              return 'Debe tener al menos 8 caracteres';
            }
            return null;
          },
        ),

        const SizedBox(height: AppSpacing.md),

        // Campo deshabilitado para mostrar estado
        const ui.EnhancedTextField(
          label: 'Campo deshabilitado',
          hint: 'No editable',
          enabled: false,
          prefixIcon: Icons.info_outline,
        ),
      ],
    );
  }

  Widget _buildNotificationExamples() {
    return Column(
      children: [
        // Badges de notificación
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ui.NotificationBadge(
              count: _notificationCount,
              child: IconButton(
                icon: const Icon(Icons.notifications),
                iconSize: AppIcons.large,
                onPressed: () {
                  setState(() {
                    _notificationCount = _notificationCount > 0 ? 0 : 5;
                  });
                },
              ),
            ),
            ui.NotificationBadge(
              count: 99,
              backgroundColor: AppColors.warning,
              child: IconButton(
                icon: const Icon(Icons.message),
                iconSize: AppIcons.large,
                onPressed: () {
                  // Acción de mensajes
                },
              ),
            ),
            ui.NotificationBadge(
              count: 150, // Se mostrará como "99+"
              backgroundColor: AppColors.success,
              child: IconButton(
                icon: const Icon(Icons.favorite),
                iconSize: AppIcons.large,
                onPressed: () {
                  // Acción de favoritos
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          'Toca los iconos para ver las animaciones de badge. '
          'El primer icono alterna entre 5 y 0 notificaciones.',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.lg),

        // Ejemplo de notificación in-app
        ui.EnhancedCard(
          backgroundColor: AppColors.info.withOpacity(0.05),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.info,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: AppIcons.medium,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Nuevo trabajo disponible!',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                    Text(
                      'Un cliente cerca de ti necesita tus servicios. ¡Responde ahora!',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Acción de notificación
                },
                child: const Text('Ver'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información UX/UI'),
        content: const Text(
          'Estos componentes implementan principios de retención de atención, '
          'micro-interacciones y gamificación para mejorar la experiencia del usuario. '
          'Cada elemento está diseñado para optimizar la conversión y engagement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
        shape: const RoundedRectangleBorder(borderRadius: AppBorders.medium),
      ),
    );
  }
}

/// Guía de mejores prácticas para componentes UX/UI
class UXUIBestPractices {
  /// CTAs Efectivos
  static const List<String> ctaTips = [
    '• Usa primera persona: "Sí, quiero", "Lo necesito"',
    '• Crea urgencia: "Solo hoy", "Últimas 24 horas"',
    '• Destaca beneficios: "Aumenta ingresos", "Ahorra tiempo"',
    '• Colores psicológicos: Azul confianza, Verde éxito, Rojo urgencia',
    '• Tamaño mínimo 44px para accesibilidad táctil',
  ];

  /// Micro-interacciones
  static const List<String> microInteractionTips = [
    '• Duración 150-350ms para percepción natural',
    '• Feedback inmediato al tocar elementos',
    '• Animaciones que comunican estado (loading, éxito, error)',
    '• Transiciones suaves entre pantallas',
    '• Hover effects para elementos interactivos',
  ];

  /// Gamificación
  static const List<String> gamificationTips = [
    '• Barras de progreso para motivar completación',
    '• Badges y niveles para reconocimiento',
    '• Estadísticas visuales para mostrar logros',
    '• Retos y metas claras con recompensas',
    '• Feedback positivo por acciones completadas',
  ];

  /// Retención de Atención (8 segundos)
  static const List<String> attentionRetentionTips = [
    '• Primera impresión impactante (logo, colores)',
    '• Jerarquía visual clara con tipografía escalada',
    '• Contenido visual vs solo texto (65% mejor retención)',
    '• Información progresiva, no sobrecargar',
    '• CTAs visibles sin scroll en pantallas principales',
  ];
}

/// Métricas UX recomendadas para tracking
class UXMetrics {
  static const Map<String, String> keyMetrics = {
    'Time to First Interaction': 'Tiempo hasta primera interacción del usuario',
    'CTA Click Rate': 'Porcentaje de clicks en llamadas a la acción',
    'Form Completion Rate': 'Porcentaje de formularios completados',
    'Session Duration': 'Tiempo promedio de sesión del usuario',
    'Bounce Rate': 'Porcentaje de usuarios que abandonan rápidamente',
    'Task Completion Rate': 'Porcentaje de tareas completadas exitosamente',
    'Error Recovery Rate': 'Velocidad de recuperación ante errores',
    'User Satisfaction Score': 'Puntuación de satisfacción (NPS, CSAT)',
  };

  static const List<String> implementationTips = [
    '• Implementa analytics de micro-interacciones',
    '• Rastrea patrones de navegación del usuario',
    '• Mide tiempo en pantallas críticas',
    '• Analiza puntos de abandono en flujos',
    '• A/B testing de diferentes variantes de CTAs',
    '• Heatmaps para entender áreas de interés',
    '• Feedback directo del usuario con encuestas in-app',
  ];
}
