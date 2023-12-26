import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              "Email",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      emailController.clear();
                    },
                    icon: Icon(Icons.clear)),
                hintText: 'Your email',
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
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.password),
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
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                // Memastikan email dan password tidak kosong sebelum melakukan login
                if (email.isNotEmpty && password.isNotEmpty) {
                  _authController.login(email, password);
                } else {
                  // Menampilkan pesan kesalahan jika email atau password kosong
                  Get.snackbar(
                    'Error',
                    'Please fill in all fields.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
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
