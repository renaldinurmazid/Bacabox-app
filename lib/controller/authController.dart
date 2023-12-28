import 'package:bacabox/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum UserRole { Admin, Kasir, Owner }

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  RxString userName = RxString('');

  Rx<UserRole> userRole = UserRole.Admin.obs;

   UserRole getCurrentUserRole() {
    return userRole.value;
  }

  Future<void> login(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        String role = userData['role'];

        UserModel user = UserModel.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
        userName.value = user.name;

        switch (role.toLowerCase()) {
          case 'admin':
            userRole.value = UserRole.Admin;
            break;
          case 'kasir':
            userRole.value = UserRole.Kasir;
            break;
          case 'owner':
            userRole.value = UserRole.Owner;
            break;
          default:
            userRole.value = UserRole.Admin; 
            break;
        }
        Get.offNamed('/home');
        Get.snackbar(
          'Login Success',
          'Welcome ${querySnapshot.docs.first['name']}',
        );
      } else {
        Get.snackbar(
          'Login Error',
          'User not found or invalid credentials',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Error',
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
    Get.snackbar('Sign Out', 'You have been signed out');
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

  Future<int> countUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
