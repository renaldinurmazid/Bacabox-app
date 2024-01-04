import 'package:bacabox/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool shouldUpdate = false.obs;

  get book => null;

  Future<bool> addBook(Products products) async {
    try {
      await _firestore.collection('products').add(products.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding book: $e');
      return false;
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  Future<bool> updateBook(String id, String namaProduk, double hargaProduk,
      String updated_at) async {
    try {
      await _firestore.collection('products').doc(id).update({
        'nama_produk': namaProduk,
        'harga_produk': hargaProduk,
        'updated_at': updated_at,
      });
      return true;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }

  Future<int> countProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
