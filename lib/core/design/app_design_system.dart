/// Sistema de Diseño Mejorado basado en principios UX/UI
///
/// Implementa principios de retención de atención, micro-interacciones,
/// y jerarquía visual para mejorar la experiencia del usuario.
library;

import 'package:flutter/material.dart';

/// Colores del sistema de diseño con psicología del color aplicada
class AppColors {
  // Colores primarios con alta conversión
  static const Color primary = Color(0xFF2563EB); // Azul confiable
  static const Color primaryVariant = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF10B981); // Verde éxito
  static const Color secondaryVariant = Color(0xFF059669);

  // Colores de acción con urgencia
  static const Color action = Color(0xFFEF4444); // Rojo urgencia
  static const Color actionHover = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B); // Amarillo atención

  // Colores de fondo con jerarquía
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Colores de texto optimizados para lectura
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Estados interactivos
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradientes para CTAs atractivos
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Tipografía optimizada para legibilidad y jerarquía
class AppTypography {
  static const String fontFamily = 'SF Pro Display';

  // Jerarquía de títulos con contraste visual
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Texto de cuerpo optimizado para lectura
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  // Estilos para CTAs con impacto
  static const TextStyle ctaPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static const TextStyle ctaSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}

/// Espaciado consistente basado en 8px grid
class AppSpacing {
  static const double xs = 4.0; // 4px
  static const double sm = 8.0; // 8px
  static const double md = 16.0; // 16px
  static const double lg = 24.0; // 24px
  static const double xl = 32.0; // 32px
  static const double xxl = 48.0; // 48px
}

/// Bordes y esquinas con estilo moderno
class AppBorders {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));

  static const double strokeWidth = 1.5;
}

/// Sombras sutiles para profundidad
class AppShadows {
  static const List<BoxShadow> small = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
}

/// Animaciones para micro-interacciones
class AppAnimations {
  // Duraciones estándar
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);

  // Curvas de animación naturales
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounce = Curves.elasticOut;
  static const Curve smooth = Curves.fastOutSlowIn;

  // Transiciones específicas
  static const Curve buttonPress = Curves.easeIn;
  static const Curve slideIn = Curves.fastOutSlowIn;
  static const Curve fadeIn = Curves.easeOut;
}

/// Iconografía consistente
class AppIcons {
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double xl = 48.0;
}

/// Tema base de la aplicación
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      fontFamily: AppTypography.fontFamily,
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.medium),
          elevation: 2,
          textStyle: AppTypography.ctaPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        shadowColor: Color(0x14000000),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppBorders.medium),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        shadowColor: Color(0x0A000000),
        titleTextStyle: AppTypography.h3,
        centerTitle: true,
      ),
    );
  }
}
