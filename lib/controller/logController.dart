import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/model/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LogController {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
  final AuthController _authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLog(String activity) async {
    try {
      String userName = _authController.userName.value;

      await logsCollection.add({
        'activity': activity,
        'created_at': DateTime.now().toString(),
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

  Future<int> countLog() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('logs').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
