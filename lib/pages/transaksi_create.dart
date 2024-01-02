import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/controller/transaksiController.dart';
import 'package:bacabox/model/transaksi.dart';
import 'package:bacabox/pages/successtransaksi.dart';
import 'package:bacabox/theme/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiCreate extends StatefulWidget {
  @override
  State<TransaksiCreate> createState() => _TransaksiCreateState();
}

class _TransaksiCreateState extends State<TransaksiCreate> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  List<String> produkList = [];
  double _hargaProduk = 0.0;
  double _totalBelanja = 0.0;

  final TextEditingController _namaPembeliController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final LogController logController = LogController();

  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

  final TextEditingController _hargaProdukController = TextEditingController();

  void calculateTotalBelanja() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    setState(() {
      _totalBelanja = _hargaProduk * qty;
    });
  }

  void fetchBookPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('title', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaProduk = querySnapshot.docs.first['price'];

        setState(() {
          _hargaProduk = hargaProduk;
          _hargaProdukController.text =
              "Rp. ${_hargaProduk.toStringAsFixed(2)}";
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
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('books').get();

    setState(() {
      produkList =
          querySnapshot.docs.map((doc) => doc['title']).toList().cast<String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colour.secondary,
          title: Text('Create Transaksi',
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
                  controller: _namaPembeliController,
                  decoration: InputDecoration(
                    hintText: 'Exm. Renaldi Nurmazid',
                    label: Text(
                      'Nama Pembeli',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  )),
              SizedBox(
                height: 20,
              ),
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
                      fetchBookPrice(
                          newValue);
                    });
                  },
                  items:
                      produkList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                          fontFamily: 'Poppins'),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _qtyController,
                  onChanged: (value) {
                    calculateTotalBelanja(); // Panggil fungsi untuk menghitung total belanja saat nilai qty berubah
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Exm. 50',
                    label: Text(
                      'QTY',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  )),
              SizedBox(
                height: 20,
              ),
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
                          fontFamily: 'Poppins'),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Belanja",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${currencyFormatter.format(_totalBelanja)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colour.primary,
                  ),
                  onPressed: () async {
                    String namaPembeli = _namaPembeliController.text.trim();
                    int qty = int.tryParse(_qtyController.text.trim()) ?? 0;
                    double uangBayar = double.tryParse(_uangBayarController.text
                            .replaceAll(RegExp('[^0-9]'), '')) ??
                        0;

                    if (_selectedProduct != null &&
                        qty > 0 &&
                        uangBayar > 0 &&
                        namaPembeli.isNotEmpty &&
                        uangBayar >= _totalBelanja) {
                      double totalBelanja = _hargaProduk * qty;
                      double uangKembali = uangBayar - totalBelanja;

                      Transaksi newTransaksi = Transaksi(
                        namaPembeli: namaPembeli,
                        namaProduk: _selectedProduct!,
                        hargaProduk: _hargaProduk,
                        qty: qty,
                        uangBayar: uangBayar,
                        totalBelanja: totalBelanja,
                        uangKembali: uangKembali,
                        tanggaltransaksi: DateTime.now().toString(),
                      );
                      _addLog("Add Transaksi");
                      Get.to(() => TransaksiS(
                            namaPembeli: namaPembeli,
                            namaBarang: _selectedProduct!,
                            hargaSatuan: _hargaProduk,
                            qty: qty,
                            totalBelanja: totalBelanja,
                            uangBayar: uangBayar,
                            uangKembali: uangKembali,
                          ));
                      Get.snackbar('Success', 'Transaksi added successfully');

                      bool success =
                          await _transaksiController.addTransaksi(newTransaksi);

                      if (success) {
                        _namaPembeliController.clear();
                        _qtyController.clear();
                        _uangBayarController.clear();
                        _hargaProdukController.clear();
                        _totalBelanja = 0;
                        setState(() {
                          _selectedProduct = null;
                        });
                      } else {
                        print('Failed to add transaction to the database');
                      }
                    } else {
                      Get.snackbar(
                          'Failed', 'Silakan periksa kembali transaksi.');
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Poppins')),
                ),
              ),
            ])));
  }

  void updateTotalBelanja() {
    double hargaProduk = _hargaProduk;
    int qty = int.tryParse(_qtyController.text) ?? 0;
    double totalBelanja = hargaProduk * qty;

    setState(() {
      _totalBelanja = totalBelanja;
    });
  }

  Future<void> _addLog(String message) async {
    try {
      await logController
          .addLog(message); // Menambahkan log saat tombol ditekan
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
