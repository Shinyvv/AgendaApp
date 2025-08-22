import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Servicio para manejar usuarios y roles
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _usersCollection = 'users';

  /// Helper para logging condicional solo en debug
  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('🔧 UserService: $message');
    }
  }

  /// Obtener datos del usuario actual desde Firestore
  Stream<AppUser?> getCurrentUserData() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return AppUser.fromJson(doc.data()!);
        });
  }

  /// Crear o actualizar usuario en Firestore con retry
  Future<void> createOrUpdateUser(AppUser user) async {
    _debugLog('=== INICIANDO createOrUpdateUser ===');
    _debugLog('Usuario: ${user.uid} (${user.email})');
    _debugLog('Rol: ${user.role}');

    int maxRetries = 3;
    int currentRetry = 0;

    while (currentRetry < maxRetries) {
      try {
        _debugLog('🔄 Intento ${currentRetry + 1} de $maxRetries');

        // Test connectivity first
        _debugLog('🌐 Verificando conectividad con Firestore...');
        await _firestore.enableNetwork();
        _debugLog('✅ Red habilitada');

        // Perform the operation with extended timeout
        _debugLog('💾 Escribiendo documento con ID: ${user.uid}');
        await _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () {
                _debugLog('❌ TIMEOUT en set() - Intento ${currentRetry + 1}');
                throw 'timeout_firestore_set';
              },
            );

        _debugLog('✅ createOrUpdateUser completado exitosamente');
        return; // Success - exit retry loop
      } catch (e) {
        currentRetry++;
        _debugLog('❌ Error en intento $currentRetry: $e');

        if (currentRetry >= maxRetries) {
          _debugLog('💀 Agotados todos los intentos ($maxRetries)');
          rethrow; // Use rethrow instead of throw e
        }

        // Wait before retry
        int waitTime = currentRetry * 2; // Progressive backoff: 2s, 4s, 6s
        _debugLog('⏳ Esperando ${waitTime}s antes del siguiente intento...');
        await Future.delayed(Duration(seconds: waitTime));
      }
    }
  }

  /// Cambiar rol de usuario (y crear usuario si no existe)
  Future<void> changeUserRole(String userId, UserRole newRole) async {
    _debugLog('=== INICIANDO CAMBIO DE ROL ===');
    _debugLog('UserId: $userId');
    _debugLog('Nuevo rol: ${newRole.name}');

    try {
      _debugLog('Intentando actualizar documento existente...');
      _debugLog('Colección: $_usersCollection');
      _debugLog('Documento ID: $userId');

      // Intentar actualizar el documento existente con timeout
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
            'role': newRole.name,
            'lastSignIn': DateTime.now().toIso8601String(),
          })
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              _debugLog(
                '⚠️ TIMEOUT en update - documento probablemente no existe',
              );
              throw 'timeout_update';
            },
          );

      _debugLog(
        '✅ Documento actualizado exitosamente con rol: ${newRole.name}',
      );
    } catch (e) {
      _debugLog('⚠️ Error al actualizar rol: $e');
      _debugLog('🔧 Intentando crear usuario desde Firebase Auth...');

      // Si el documento no existe, crear el usuario desde Firebase Auth
      final firebaseUser = _auth.currentUser;
      _debugLog('🔧 Firebase User obtenido: ${firebaseUser?.uid}');
      _debugLog('🔧 Email del Firebase User: ${firebaseUser?.email}');

      if (firebaseUser != null && firebaseUser.uid == userId) {
        _debugLog('🔧 IDs coinciden, creando AppUser...');
        final appUser = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName,
          photoURL: firebaseUser.photoURL,
          role: newRole,
          createdAt: DateTime.now(),
          lastSignIn: DateTime.now(),
          isActive: true,
        );

        _debugLog('🔧 AppUser creado: ${appUser.toString()}');
        _debugLog('🔧 Llamando createOrUpdateUser con timeout...');

        await createOrUpdateUser(appUser).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            _debugLog('❌ TIMEOUT en createOrUpdateUser');
            throw 'timeout_create';
          },
        );

        _debugLog('✅ Usuario creado exitosamente con rol: ${newRole.name}');
      } else {
        _debugLog(
          '❌ ERROR - Firebase Auth user no encontrado o UIDs no coinciden',
        );
        _debugLog('❌ Firebase User UID: ${firebaseUser?.uid}');
        _debugLog('❌ Expected UID: $userId');
        throw 'No se pudo crear el usuario: Firebase Auth user no encontrado o UIDs no coinciden';
      }
    }

    _debugLog('🏁 === CAMBIO DE ROL COMPLETADO ===');
  }

  /// Obtener todos los trabajadores
  Stream<List<AppUser>> getAllWorkers() {
    return _firestore
        .collection(_usersCollection)
        .where('role', isEqualTo: UserRole.trabajador.name)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppUser.fromJson(doc.data())).toList(),
        );
  }

  /// Obtener todos los usuarios
  Stream<List<AppUser>> getAllUsers() {
    return _firestore
        .collection(_usersCollection)
        .where('role', isEqualTo: UserRole.usuario.name)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppUser.fromJson(doc.data())).toList(),
        );
  }

  /// Completar perfil de trabajador
  Future<void> completeWorkerProfile({
    required String userId,
    required List<String> specialties,
    required Map<String, dynamic> workingHours,
    String? phoneNumber,
  }) async {
    final updates = {
      'specialties': specialties.join(','), // Simplificado por ahora
      'workingHours': workingHours.toString(), // Simplificado por ahora
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'lastSignIn': FieldValue.serverTimestamp(),
    };

    await _firestore.collection(_usersCollection).doc(userId).update(updates);
  }

  /// Verificar si el usuario tiene un permiso específico
  Future<bool> hasPermission(String userId, String permission) async {
    final userDoc = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .get();

    if (!userDoc.exists) return false;

    final user = AppUser.fromJson(userDoc.data()!);
    return user.hasPermission(permission);
  }

  /// Actualizar rating de trabajador
  Future<void> updateWorkerRating(String workerId, double newRating) async {
    await _firestore.collection(_usersCollection).doc(workerId).update({
      'rating': newRating,
    });
  }

  /// Incrementar trabajos completados
  Future<void> incrementCompletedJobs(String workerId) async {
    await _firestore.collection(_usersCollection).doc(workerId).update({
      'completedJobs': FieldValue.increment(1),
      'lastSignIn': FieldValue.serverTimestamp(),
    });
  }

  /// Crear usuario desde Firebase Auth
  Future<AppUser> createUserFromFirebaseAuth(
    User firebaseUser, {
    UserRole? role,
  }) async {
    final appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      role: role ?? UserRole.usuario,
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
      isActive: true,
    );

    await createOrUpdateUser(appUser);
    return appUser;
  }
}

/// Provider para el servicio de usuarios
final userServiceProvider = Provider<UserService>((ref) => UserService());

/// Provider para obtener los datos del usuario actual
final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final userService = ref.read(userServiceProvider);
  return userService.getCurrentUserData();
});

/// Provider para verificar si el usuario actual es trabajador
final isWorkerProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentAppUserProvider);
  return currentUser.when(
    data: (user) => user?.isWorker ?? false,
    loading: () => false,
    error: (_, _) => false,
  );
});

/// Provider para verificar si el usuario actual es usuario regular
final isRegularUserProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentAppUserProvider);
  return currentUser.when(
    data: (user) => user?.isUser ?? true,
    loading: () => true,
    error: (_, _) => true,
  );
});

/// Provider para obtener todos los trabajadores
final allWorkersProvider = StreamProvider<List<AppUser>>((ref) {
  final userService = ref.read(userServiceProvider);
  return userService.getAllWorkers();
});

/// Provider para verificar permisos específicos
final permissionProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  permission,
) {
  final currentUser = ref.watch(currentAppUserProvider);
  return currentUser.when(
    data: (user) => AsyncValue.data(user?.hasPermission(permission) ?? false),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
