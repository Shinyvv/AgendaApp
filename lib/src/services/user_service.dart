import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

/// Servicio para manejar usuarios y roles
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _usersCollection = 'users';

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

  /// Crear o actualizar usuario en Firestore
  Future<void> createOrUpdateUser(AppUser user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  /// Cambiar rol de usuario (y crear usuario si no existe)
  Future<void> changeUserRole(String userId, UserRole newRole) async {
    try {
      // Intentar actualizar el documento existente
      await _firestore.collection(_usersCollection).doc(userId).update({
        'role': newRole.name,
      });
    } catch (e) {
      print('Error al actualizar rol, creando usuario: $e');

      // Si el documento no existe, crear el usuario desde Firebase Auth
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null && firebaseUser.uid == userId) {
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

        await createOrUpdateUser(appUser);
        print('Usuario creado con rol: ${newRole.name}');
      } else {
        throw 'No se pudo crear el usuario: Firebase Auth user no encontrado';
      }
    }
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
    error: (_, __) => false,
  );
});

/// Provider para verificar si el usuario actual es usuario regular
final isRegularUserProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentAppUserProvider);
  return currentUser.when(
    data: (user) => user?.isUser ?? true,
    loading: () => true,
    error: (_, __) => true,
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
