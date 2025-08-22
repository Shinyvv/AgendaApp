import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../src/models/user_model.dart';
import '../../src/services/user_service.dart';

/// Servicio de autenticación centralizado
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  /// Stream del estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actual
  User? get currentUser => _auth.currentUser;

  /// Registrarse con email y contraseña
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    UserRole? role, // Permitir seleccionar rol al registrarse
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Actualizar el perfil del usuario
      await userCredential.user?.updateDisplayName(displayName);

      // Crear usuario con rol en Firestore
      if (userCredential.user != null) {
        await _userService.createUserFromFirebaseAuth(
          userCredential.user!,
          role: role,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Iniciar sesión con Google usando flujo NATIVO (sin navegador)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Para web, usar Firebase Auth
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        final userCredential = await _auth.signInWithPopup(googleProvider);

        // Usuario será creado en role_selection_screen con el rol correcto
        // No crear aquí para evitar operaciones duplicadas de Firestore

        return userCredential;
      } else {
        // Para móvil: Usar GoogleSignIn 6.x con configuración nativa
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );

        try {
          // Cerrar cualquier sesión previa
          await googleSignIn.signOut();

          // Iniciar el flujo de autenticación nativo
          final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

          if (googleUser == null) {
            return null; // Usuario canceló
          }

          // Obtener las credenciales de autenticación
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          if (googleAuth.accessToken == null) {
            throw 'No se pudo obtener el token de acceso';
          }

          // Crear credencial de Firebase
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Autenticar con Firebase
          final UserCredential userCredential = await _auth
              .signInWithCredential(credential);

          // Usuario será creado en role_selection_screen con el rol correcto
          // No crear aquí para evitar operaciones duplicadas de Firestore

          return userCredential;
        } catch (e) {
          await googleSignIn.signOut();
          rethrow;
        }
      }
    } catch (e) {
      throw 'Error al iniciar sesión con Google: ${e.toString()}';
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Manejar excepciones de Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró un usuario con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'El email no tiene un formato válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde.';
      default:
        return e.message ?? 'Ocurrió un error desconocido.';
    }
  }
}

/// Provider del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Provider del estado de autenticación
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider del usuario actual
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, _) => null,
  );
});
