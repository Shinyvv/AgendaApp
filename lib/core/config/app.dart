import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import '../constants/app_constants.dart';
import '../design/app_design_system.dart';

/// Aplicación principal de Agenda App
///
/// Esta clase configura el tema, la navegación y otros aspectos
/// fundamentales de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.createRouter(ref);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Aplicar el tema mejorado con principios UX/UI
      theme: AppTheme.lightTheme,

      // Configuración de navegación
      routerConfig: router,
    );
  }
}
