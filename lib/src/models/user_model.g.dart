// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoURL: json['photoURL'] as String?,
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.usuario,
  phoneNumber: json['phoneNumber'] as String?,
  createdAt: _dateFromJson(json['createdAt']),
  lastSignIn: _dateFromJson(json['lastSignIn']),
  isActive: json['isActive'] as bool? ?? true,
  specialties: json['specialties'] as String?,
  workingHours: json['workingHours'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  completedJobs: (json['completedJobs'] as num?)?.toInt(),
  preferredLocation: json['preferredLocation'] as String?,
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'role': _$UserRoleEnumMap[instance.role]!,
  'phoneNumber': instance.phoneNumber,
  'createdAt': _dateToJson(instance.createdAt),
  'lastSignIn': _dateToJson(instance.lastSignIn),
  'isActive': instance.isActive,
  'specialties': instance.specialties,
  'workingHours': instance.workingHours,
  'rating': instance.rating,
  'completedJobs': instance.completedJobs,
  'preferredLocation': instance.preferredLocation,
};

const _$UserRoleEnumMap = {
  UserRole.usuario: 'usuario',
  UserRole.trabajador: 'trabajador',
};
