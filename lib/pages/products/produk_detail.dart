import 'package:bacabox/controller/bookController.dart';
import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdukDetail extends StatelessWidget {
  final BookController _bookController = Get.put(BookController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final LogController logController = LogController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String nama_produk = args?['nama_produk'] ?? '';
    final double harga_produk = args?['harga_produk'] ?? 0.0;

    titleController.text = nama_produk;
    priceController.text = harga_produk.toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colour.secondary,
        title: Text('Detail Produk',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
          color: Colour.secondary,
          padding: const EdgeInsets.all(20),
          child: Column(children: [
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
                hintText: 'Exm. Rp. 100.000',
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          String nama_produk = titleController.text.trim();
                          double harga_produk =
                              double.tryParse(priceController.text.trim()) ??
                                  0.0;
                          String updated_at = DateTime.now().toString();
                          if (nama_produk.isNotEmpty && harga_produk > 0) {
                            await _bookController.updateBook(
                              id,
                              titleController.text,
                              double.parse(priceController.text),
                              updated_at,
                            );

                            _bookController.shouldUpdate.value = true;
                            Get.back();
                            _addLog("Updated book with title: $nama_produk");
                            Get.snackbar(
                                'Success', 'Book updated successfully!');
                          } else {
                            Get.snackbar('Failed',
                                'Gagal memperbarui buku, silakan periksa kembali form.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colour.primary),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          bool success = await _bookController.deleteBook(id);
                          if (success) {
                            Get.back();
                            Get.snackbar(
                                'Success', 'Book deleted successfully!');
                            _addLog("Deleted book with title: $nama_produk");
                          } else {
                            Get.snackbar('Failed', 'Failed to delete book');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        )),
                  ]),
            )
          ])),
    );
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController
          .addLog(activity); // Menambahkan log saat tombol ditekan
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
