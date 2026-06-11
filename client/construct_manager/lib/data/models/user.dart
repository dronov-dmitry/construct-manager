class User {
  final String uid;
  final String name;
  final String email;
  final bool admin;
  final bool isEmailVerified;
  final String role;

  const User({
    this.uid = '',
    this.name = '',
    this.email = '',
    this.admin = false,
    this.isEmailVerified = false,
    this.role = 'executor',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      admin: json['admin'] as bool? ?? false,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      role: json['role'] as String? ?? 'executor',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'admin': admin,
      'is_email_verified': isEmailVerified,
      'role': role,
    };
  }
}
