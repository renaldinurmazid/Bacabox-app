import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/model/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogController {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
  final AuthController _authController = Get.find<AuthController>();

  Future<void> addLog(String message) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userName = _authController.userName.value;

      await logsCollection.add({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'userName': userName,
      });
    } catch (e) {
      throw Exception('Failed to add log: $e');
    }
  }

  Stream<List<Log>> getLogsStream() {
    return logsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Log.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
