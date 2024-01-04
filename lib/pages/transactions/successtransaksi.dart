import 'dart:typed_data';
import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:image/image.dart' as img;

class TransaksiS extends StatefulWidget {
  final int nomor_unik;
  final String namaPelanggan;
  final String namaBarang;
  final double hargaSatuan;
  final int qty;
  final double totalBelanja;
  final double uangBayar;
  final double uangKembali;
  final String created_at;

  const TransaksiS(
      {required this.nomor_unik,
      required this.namaPelanggan,
      required this.namaBarang,
      required this.hargaSatuan,
      required this.qty,
      required this.totalBelanja,
      required this.uangBayar,
      required this.uangKembali,
      required this.created_at});

  @override
  State<TransaksiS> createState() => _TransaksiSState();
}

class _TransaksiSState extends State<TransaksiS> {
  final AuthController _authController = Get.find<AuthController>();

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  @override
  Widget build(BuildContext context) {
    Future<Uint8List> resizeImage(
        Uint8List imageBytes, int newWidth, int newHeight) async {
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Gagal mendecode gambar.');
      }

      img.Image resizedImage =
          img.copyResize(image, width: newWidth, height: newHeight);

      Uint8List resizedImageBytes =
          Uint8List.fromList(img.encodePng(resizedImage));

      return resizedImageBytes;
    }

    Future<Uint8List> loadAndProcessImage() async {
      ByteData bytesAsset = await rootBundle.load("images/logo.png");
      Uint8List imageBytesFromAsset = bytesAsset.buffer
          .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

      return imageBytesFromAsset;
    }

    Future<Uint8List> printImageUsingPrinter() async {
      Uint8List imageBytes = await loadAndProcessImage();
      return imageBytes;
    }

    void myFunction() async {
      final currencyFormatter =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

      Future<Uint8List> imageFuture = printImageUsingPrinter();

      Uint8List? originalImageBytes = await imageFuture;

      Uint8List resizedImageBytes =
          await resizeImage(originalImageBytes, 100, 100);

      printer.printImageBytes(resizedImageBytes);
      printer.printCustom("Bacabox", 2, 1);
      printer.printNewLine();
      printer.printLeftRight("No. Struk", "${widget.nomor_unik}", 1);
      printer.printLeftRight("Nama Kasir", "${_authController.userName}", 1);
      printer.printLeftRight(
        "Tanggal",
        "${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.created_at))}",
        1,
      );
      printer.printNewLine();
      printer.printLeftRight("Barang", "${widget.namaBarang}", 1);
      printer.printLeftRight(
          "Harga Satuan", "${currencyFormatter.format(widget.hargaSatuan)}", 1);
      printer.printLeftRight("QTY", "${widget.qty}", 1);
      printer.printLeftRight("Total Belanja",
          "${currencyFormatter.format(widget.totalBelanja)}", 1);
      printer.printLeftRight(
          "Uang Bayar", "${currencyFormatter.format(widget.uangBayar)}", 1);
      printer.printLeftRight(
          "Uang Kembali", "${currencyFormatter.format(widget.uangKembali)}", 1);
      printer.printNewLine();
      printer.printCustom("Terima Kasih", 2, 1);
      printer.printNewLine();
      printer.printNewLine();
    }

    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colour.secondary,
        padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
        child: Column(children: [
          Container(
            child: Image(
              image: AssetImage('images/success.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Transaksi Berhasil",
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Uang Kembalian",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${currencyFormatter.format(widget.uangKembali)}",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Rincian Pembelian",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "No. Struk",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${widget.nomor_unik}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama Pembeli",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${widget.namaPelanggan}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama Barang",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${widget.namaBarang}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Harga Satuan",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${currencyFormatter.format(widget.hargaSatuan)}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "QTY",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${widget.qty}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Belanja",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${currencyFormatter.format(widget.totalBelanja)}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Uang Bayar",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${currencyFormatter.format(widget.uangBayar)}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Uang Kembali",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        "${currencyFormatter.format(widget.uangKembali)}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ]),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colour.primary),
                onPressed: () {
                  printer.printNewLine();
                  myFunction();
                  Get.back();
                },
                child: Text(
                  "Selesai",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          )
        ]),
      ),
    );
  }
}
