import 'package:bacabox/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool shouldUpdate = false.obs;

  Future<bool> addBook(Book book) async {
    try {
      await _firestore.collection('books').add(book.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding book: $e');
      return false;
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      await _firestore.collection('books').doc(id).delete();
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  Future<bool> updateBook(String id, String newTitle, double newPrice) async {
    try {
      await _firestore.collection('books').doc(id).update({
        'title': newTitle,
        'price': newPrice,
      });
      return true;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }
}
