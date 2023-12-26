import 'package:bacabox/model/transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Transaksi> transaksiList = <Transaksi>[].obs;
  RxBool shouldUpdate = false.obs;

  Future<bool> addTransaksi(Transaksi transaksi) async {
    try {
      await _firestore.collection('transaksi').add(transaksi.toMap());
      print('Transaction added successfully!');
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  Future<bool> deleteTransaksi(String id) async {
    try {
      await _firestore.collection('transaksi').doc(id).delete();
      print('Transaction deleted successfully!');
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  Future<bool> updateTransaksi(Transaksi transaksi) async {
    try {
      await _firestore
          .collection('transaksi')
          .doc(transaksi.id)
          .update(transaksi.toMap());
      print('Transaction updated successfully!');
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  void clearTransaksiList() {
    transaksiList.clear();
  }
}
