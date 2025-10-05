enum Role { student, teacher }

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final Role role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
  });
}
