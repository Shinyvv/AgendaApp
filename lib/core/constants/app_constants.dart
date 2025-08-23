/// Constantes globales de la aplicación Agenda App
///
/// Este archivo centraliza todas las constantes utilizadas
/// a lo largo de la aplicación para facilitar su mantenimiento.
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  /// Configuración de la aplicación
  static const String appName = 'Agenda App';
  static const String appVersion = '1.0.0';

  /// Configuración de Firebase
  static const String firebaseProjectId = 'agendaapptry';

  /// Configuración de rutas
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String userDashboardRoute = '/dashboard/user';
  static const String workerDashboardRoute = '/dashboard/worker';

  /// Configuración de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  /// Configuración de Firebase Auth
  static const int authTokenPropagationDelayMs = 500;

  /// Roles de usuario
  static const String userRole = 'user';
  static const String workerRole = 'worker';

  /// Estados de usuario
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';
}
