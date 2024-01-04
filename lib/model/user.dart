class UserModel {
  final String password;
  final String role;
  final String name;
  final String username;
  final String created_at;
  final String updated_at;

  UserModel({
    required this.password,
    required this.role,
    required this.name,
    required this.username,
    required this.created_at,
    required this.updated_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      password: json['password'],
      role: json['role'],
      name: json['name'],
      username: json['username'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'role': role,
      'name': name,
      'username': username,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
