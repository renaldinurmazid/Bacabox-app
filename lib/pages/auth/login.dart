import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.secondary,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100),
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sign in to your account",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Username",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      usernameController.clear();
                    },
                    icon: Icon(Icons.clear)),
                hintText: 'Your Username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    togglePasswordVisibility();
                  },
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                ),
                hintText: 'Your password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colour.primary,
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                String username = usernameController.text.trim();
                String password = passwordController.text.trim();

                if (username.isNotEmpty && password.isNotEmpty) {
                  _authController.login(username, password);
                } else {
                  Get.snackbar('Error', 'Silakan lengkapi form.');
                }
              },
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
