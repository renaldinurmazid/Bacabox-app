import 'package:bacabox/controller/bookController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdukDetail extends StatelessWidget {
  final BookController _bookController = Get.put(BookController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String title = args?['title'] ?? '';
    final double price = args?['price'] ?? 0.0;

    titleController.text = title;
    priceController.text = price.toStringAsFixed(0);
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
                          bool success = await _bookController.updateBook(
                            id,
                            titleController.text,
                            double.parse(priceController.text),
                          );

                          if (success) {
                            _bookController.shouldUpdate.value = true;
                            Get.back(); // Kembali ke halaman produk
                          } else {
                            print(
                                'Failed to add book, staying on /produkcreate');
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
                            _bookController.shouldUpdate.value = true;
                            Get.back(); // Kembali ke halaman produk
                          } else {
                            print(
                                'Failed to add book, staying on /produkcreate');
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
}
