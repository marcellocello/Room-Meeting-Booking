import 'package:equatable/equatable.dart';

enum UserRole { admin, manager, staff, display }

class UserModel extends Equatable {
  final String id;
  final String orgId;
  final String name;
  final String email;
  final UserRole role;
  final bool isActive;
  final String accessToken;
  final String refreshToken;

  const UserModel({
    required this.id,
    required this.orgId,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.accessToken,
    required this.refreshToken
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.staff,
      ),
      isActive: json['is_active'] as bool? ?? true,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'org_id': orgId,
    'name': name,
    'email': email,
    'role': role.name,
    'is_active': isActive,
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };

  @override
  List<Object> get props => [id, orgId, name, email, role, isActive, accessToken];
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException($code): $message';
}