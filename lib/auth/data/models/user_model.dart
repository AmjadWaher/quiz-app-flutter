import 'package:quiz_app/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
    required super.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      token: json['token'],
      role: json['role'] == "Admin" ? Role.teacher : Role.student,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    Role? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': name,
      'email': email,
      'role': role.name.replaceFirst(role.name[0], role.name[0].toUpperCase()),
    };
  }
}
