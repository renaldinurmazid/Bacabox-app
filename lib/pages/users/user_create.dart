import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogController logController = LogController();

  String? _selectedRole;

  List<String> _roles = ['Admin', 'Kasir', 'Owner'];

  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _createUsername(String value) {
      String username = value.toLowerCase().replaceAll(' ', '');
      usernameController.text = username;
    }

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
                onChanged: (value) {
                  _createUsername(value);
                },
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
                enabled: false,
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
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colour.primary,
                    ),
                    onPressed: () {
                      String password = passwordController.text.trim();
                      String name = nameController.text.trim();
                      String username = usernameController.text.trim();
                      String created_at = DateTime.now().toString();
                      String updated_at = DateTime.now().toString();

                      if (username.isNotEmpty &&
                          password.isNotEmpty &&
                          name.isNotEmpty &&
                          _selectedRole != null) {
                        _authController.register(
                            password, _selectedRole!, name, username,created_at,updated_at);
                        Get.back();
                        Get.snackbar('Success', 'User created successfully!');
                        _addLog('Created new user');
                      } else {
                        Get.snackbar('Error', 'Please fill in all fields');
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    )),
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
