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
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  Future<bool> updateTransaksi(
      String id,
      String namaPembeli,
      String namaProduk,
      double hargaProduk,
      int qty,
      double uangBayar,
      double totalBelanja,
      double uangKembali,
      String updated_at) async {
    try {
      await _firestore.collection('transaksi').doc(id).update({
        'namaPembeli': namaPembeli,
        'namaProduk': namaProduk,
        'hargaProduk': hargaProduk,
        'qty': qty,
        'uangBayar': uangBayar,
        'totalBelanja': totalBelanja,
        'uangKembali': uangKembali,
        'updated_at': updated_at,
      });
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

  Future<int> countTransaksi() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('transaksi').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
