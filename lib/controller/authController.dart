import 'package:bacabox/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  Future<void> login(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.offNamed('/home');
      } else {
        Get.snackbar('Login Error', 'User not found or invalid credentials',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
  }

  Future<void> register(
      String email, String password, String role, String name) async {
    try {
      UserModel newUser = UserModel(
        email: email,
        password: password,
        role: role,
        name: name,
      );

      await _firestore.collection('users').add(newUser.toJson());
    } catch (e) {
      Get.snackbar('Registration Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateUser(String userId, String email, String role, String name,
      String password) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'email': email,
        'role': role,
        'name': name,
        'password': password,
      });
      Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      Get.snackbar('Update Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }
}
