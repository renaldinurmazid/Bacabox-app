import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final AuthController _AuthController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogController logController = LogController();

  String? _selectedRole;

  List<String> _roles = ['Admin', 'Kasir', 'Owner'];

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic>? args = Get.arguments;
    _selectedRole = args?['role'] ?? null;
    if (_selectedRole != null) {
      (_selectedRole);
    }
  }

  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String name = args?['name'] ?? '';
    final String username = args?['username'] ?? '';
    final String password = args?['password'] ?? '';

    nameController.text = name;
    usernameController.text = username;
    passwordController.text = password;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colour.secondary,
        appBar: AppBar(
            backgroundColor: Colour.secondary,
            title: Text(
              'Create User',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Exm. Renaldi Nurmazid',
                  label: Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Exm. Renaldi Nurmazid',
                  label: Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: togglePasswordVisibility,
                  ),
                  hintText: '***',
                  label: Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  hint: Text('Pilih Role'),
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colour.primary,
                        ),
                        onPressed: () {
                          String password = passwordController.text.trim();
                          String name = nameController.text.trim();
                          String username = usernameController.text.trim();
                          String updated_at = DateTime.now().toString();

                          if (username.isNotEmpty &&
                              name.isNotEmpty &&
                              _selectedRole != null) {
                            String userId = id;
                            _AuthController.updateUser(userId,
                                _selectedRole!, name, password, username, updated_at);
                            Get.back();
                            _addLog('Updated user');
                          } else {
                            Get.snackbar('Error', 'Please fill all fields');
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          bool success = await _AuthController.deleteUser(id);
                          if (success) {
                            Get.back();
                            Get.snackbar(
                                'Success', 'User deleted successfully!');
                            _addLog('Deleted user');
                          } else {
                            Get.snackbar('Failed', 'Failed to delete user');
                          }
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController.addLog(activity);
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
