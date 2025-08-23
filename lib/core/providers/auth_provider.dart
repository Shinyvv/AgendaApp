import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

/// Provider para el estado de autenticación
///
/// Este provider centraliza el estado del usuario autenticado
/// y proporciona acceso reactivo al estado de auth en toda la app.
final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider para el servicio de autenticación
///
/// Proporciona acceso al servicio de autenticación para
/// realizar operaciones como login, logout, etc.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider para obtener los datos del usuario actual desde Firestore
///
/// Combina el estado de auth con los datos del usuario almacenados
/// en Firestore para proporcionar información completa del usuario.
final currentUserDataProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);

      // Usar el UserService para obtener los datos del usuario desde Firestore
      final userService = UserService();
      return userService.getCurrentUserData();
    },
    loading: () => Stream.value(null),
    error: (error, stack) => Stream.value(null),
  );
});

/// Provider para verificar si el usuario está autenticado
///
/// Simplifica las verificaciones de autenticación en los widgets.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.asData?.value != null;
});
