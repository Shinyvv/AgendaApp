import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Tipos de roles en el sistema
enum UserRole {
  @JsonValue('usuario')
  usuario,
  @JsonValue('trabajador')
  trabajador,
}

/// Extensión para obtener información del rol
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.usuario:
        return 'Usuario';
      case UserRole.trabajador:
        return 'Trabajador';
    }
  }

  String get description {
    switch (this) {
      case UserRole.usuario:
        return 'Cliente que solicita servicios';
      case UserRole.trabajador:
        return 'Proveedor de servicios';
    }
  }

  List<String> get permissions {
    switch (this) {
      case UserRole.usuario:
        return [
          'create_booking',
          'view_own_bookings',
          'cancel_booking',
          'rate_service',
          'view_workers',
        ];
      case UserRole.trabajador:
        return [
          'view_all_bookings',
          'accept_booking',
          'reject_booking',
          'complete_booking',
          'view_earnings',
          'manage_schedule',
          'view_client_info',
        ];
    }
  }
}

/// Modelo del usuario con roles y permisos
@JsonSerializable()
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  @JsonKey(defaultValue: UserRole.usuario)
  final UserRole role;
  final String? phoneNumber;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? createdAt;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? lastSignIn;
  @JsonKey(defaultValue: true)
  final bool isActive;

  // Campos específicos para trabajadores
  final String? specialties; // JSON string de especialidades
  final String? workingHours; // JSON string de horarios
  final double? rating;
  final int? completedJobs;

  // Campos específicos para usuarios
  final String? preferredLocation;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.role = UserRole.usuario,
    this.phoneNumber,
    this.createdAt,
    this.lastSignIn,
    this.isActive = true,
    this.specialties,
    this.workingHours,
    this.rating,
    this.completedJobs,
    this.preferredLocation,
  });

  // Getters de conveniencia
  bool get isWorker => role == UserRole.trabajador;
  bool get isUser => role == UserRole.usuario;

  bool hasPermission(String permission) =>
      role.permissions.contains(permission);

  List<String> get allPermissions => role.permissions;

  // JSON serialization
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  // Copy with method
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    UserRole? role,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastSignIn,
    bool? isActive,
    String? specialties,
    String? workingHours,
    double? rating,
    int? completedJobs,
    String? preferredLocation,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      isActive: isActive ?? this.isActive,
      specialties: specialties ?? this.specialties,
      workingHours: workingHours ?? this.workingHours,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      preferredLocation: preferredLocation ?? this.preferredLocation,
    );
  }
}

// Helper methods for DateTime JSON conversion
DateTime? _dateFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
  if (timestamp is String) return DateTime.parse(timestamp);
  return null;
}

int? _dateToJson(DateTime? date) => date?.millisecondsSinceEpoch;
