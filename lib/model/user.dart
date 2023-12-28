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
  

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      role: json['role'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
    };
  }
}
