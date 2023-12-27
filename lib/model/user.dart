class UserModel {
  final String email;
  final String password;
  final String role;
  final String name;

  UserModel({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
    };
  }
}
