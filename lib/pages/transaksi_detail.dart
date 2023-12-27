import 'package:bacabox/controller/transaksiController.dart';
import 'package:bacabox/model/transaksi.dart';
import 'package:bacabox/theme/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiDetail extends StatefulWidget {
  @override
  State<TransaksiDetail> createState() => _TransaksiDetailState();
}

class _TransaksiDetailState extends State<TransaksiDetail> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  List<String> produkList = [];
  double _hargaProduk = 0.0;

  final TextEditingController _namaPembeliController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

  Future<void> updateTransaction() async {
    String id = Get.arguments['id'];
    String namaPembeli = _namaPembeliController.text.trim();
    int qty = int.tryParse(_qtyController.text.trim()) ?? 0;
    double uangBayar = double.tryParse(
            _uangBayarController.text.replaceAll(RegExp('[^0-9]'), '')) ??
        0;
    double _totalBelanja = _hargaProduk * qty;
    double _uangKembali = uangBayar - _totalBelanja;

    bool success = await _transaksiController.updateTransaksi(
        id,
        namaPembeli,
        _selectedProduct!,
        _hargaProduk,
        qty,
        uangBayar,
        _totalBelanja,
        _uangKembali);

    if (success) {
      _namaPembeliController.clear();
      _qtyController.clear();
      _uangBayarController.clear();
      _hargaProdukController.clear();
      setState(() {
        _selectedProduct = null;
      });

      Get.back();
      Get.snackbar('Success', 'Transaction updated successfully!');
    } else {
      print('Gagal memperbarui transaksi');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    final Map<String, dynamic>? args = Get.arguments;
    _selectedProduct = args?['namaProduk'] ?? null;
    if (_selectedProduct != null) {
      fetchBookPrice(_selectedProduct);
    }
  }

  Future<void> fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('books').get();

    setState(() {
      produkList =
          querySnapshot.docs.map((doc) => doc['title']).toList().cast<String>();
    });
  }

  Future<void> fetchBookPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaProduk = querySnapshot.docs.first['price'];

        setState(() {
          _hargaProduk = hargaProduk;
          _hargaProdukController.text = currencyFormatter.format(hargaProduk);
        });
      }
    } else {
      setState(() {
        _hargaProduk = 0.0;
        _hargaProdukController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String namaPembeli = args?['namaPembeli'] ?? '';
    final double uangBayar = args?['uangBayar'] ?? 0.0;
    final int qty = args?['qty'] ?? 0;

    _namaPembeliController.text = namaPembeli;
    _qtyController.text = qty.toString();
    _uangBayarController.text = uangBayar.toStringAsFixed(0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colour.secondary,
        title: Text(
          'Update Transaksi',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colour.secondary,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaPembeliController,
              decoration: InputDecoration(
                hintText: 'Exm. Renaldi Nurmazid',
                label: Text(
                  'Nama Pembeli',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              child: DropdownButton<String>(
                hint: Text('Pilih Produk'),
                value: _selectedProduct,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProduct = newValue;
                    fetchBookPrice(newValue);
                  });
                },
                items: produkList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _hargaProdukController,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Exm. Rp. 100.000',
                label: Text(
                  'Harga Produk',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
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
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Exm. 50',
                label: Text(
                  'QTY',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
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
              controller: _uangBayarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Exm. Rp. 100.000',
                label: Text(
                  'Uang Bayar',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colour.primary,
                    ),
                    onPressed: () async {
                      updateTransaction();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      bool success =
                          await _transaksiController.deleteTransaksi(id);
                      if (success) {
                        _transaksiController.shouldUpdate.value = true;
                        Get.back();
                        Get.snackbar(
                            'Success', 'Transaction deleted successfully!');
                      } else {
                        print('Failed to add book, staying on /produkcreate');
                      }
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
