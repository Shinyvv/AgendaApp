import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that listens to Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider for the current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});

/// Enum for user roles
enum AppRole { admin, employee, client }

/// Provider for user role based on custom claims
final userRoleProvider = FutureProvider<AppRole?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final token = await user.getIdTokenResult(true);
  final role = token.claims?['role'] as String?;

  switch (role) {
    case 'admin':
      return AppRole.admin;
    case 'employee':
      return AppRole.employee;
    case 'client':
      return AppRole.client;
    default:
      return null;
  }
});

/// Provider for business ID from custom claims
final businessIdProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final token = await user.getIdTokenResult(true);
  return token.claims?['businessId'] as String?;
});
