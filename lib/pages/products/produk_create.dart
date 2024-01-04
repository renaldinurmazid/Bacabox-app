import 'package:bacabox/controller/bookController.dart';
import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/model/book.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdukCreate extends StatefulWidget {
  @override
  State<ProdukCreate> createState() => _ProdukCreateState();
}

class _ProdukCreateState extends State<ProdukCreate> {
  final BookController _bookController = Get.put(BookController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final LogController logController = LogController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colour.secondary,
        title: Text('Create Produk',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Colour.secondary,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Exm. Malin Kundang',
                labelText: 'Judul Buku',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Exm. 100000',
                labelText: 'Harga Buku',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colour.primary,
                ),
                onPressed: () async {
                  String nama_produk = titleController.text.trim();
                  double harga_produk =
                      double.tryParse(priceController.text.trim()) ?? 0.0;
                  if (nama_produk.isNotEmpty && harga_produk > 0) {
                    Products newProducts = Products(
                        nama_produk: nama_produk,
                        harga_produk: harga_produk,
                        created_at: DateTime.now().toString(),
                        updated_at: DateTime.now().toString());
                    bool success = await _bookController.addBook(newProducts);

                    if (success) {
                      _bookController.shouldUpdate.value = true;
                      _addLog('Created new book: $nama_produk');
                      Get.back();
                      Get.snackbar('Success', 'Book added successfully!');
                    } else {
                      print('Failed to add book, staying on /produkcreate');
                    }
                  } else {
                    Get.snackbar('Error', 'Silakan lengkapi form.');
                  }
                },
                child: Text('Submit',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController.addLog(activity);
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
