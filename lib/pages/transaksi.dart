import 'package:bacabox/pages/transaksi_create.dart';
import 'package:bacabox/pages/transaksi_detail.dart';
// import 'package:bacabox/pages/transaksi_detail.dart';
import 'package:bacabox/theme/color.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference transaksiCollection =
      FirebaseFirestore.instance.collection('transaksi');
  var searchQuery = '';

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filterTransaksi();
    });
  }

  DateTime selectedDate = DateTime.now(); // Tanggal yang dipilih

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        filterTransaksi();
      });
    }
  }

  List<DocumentSnapshot> transaksiList = [];
  List<DocumentSnapshot> filteredTransaksi = [];

  void getTransaksi() {
    transaksiCollection.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          transaksiList = snapshot.docs;
          filterTransaksi();
        });
      } else {
        setState(() {
          transaksiList = [];
          filteredTransaksi = [];
        });
      }
    }, onError: (error) {
      print('Error getting transaksi: $error');
    });
  }

  void filterTransaksi() {
    filteredTransaksi = transaksiList.where((transaksi) {
      final namaProduk = transaksi['namaProduk'].toString().toLowerCase();
      final tanggalTransaksiString = transaksi['tanggaltransaksi'] as String;
      final tanggalTransaksi = DateTime.parse(tanggalTransaksiString);

      return namaProduk.contains(searchQuery) &&
          (selectedDate == null ||
              (tanggalTransaksi.day == selectedDate.day &&
                  tanggalTransaksi.month == selectedDate.month &&
                  tanggalTransaksi.year == selectedDate.year));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.secondary,
      appBar: AppBar(
        backgroundColor: Colour.secondary,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data Transaksi',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton(
                  color: Colour.secondary,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colour.secondary,
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            margin: EdgeInsets.all(20),
                                            width: double.infinity,
                                            child: DropdownButton<
                                                    BluetoothDevice>(
                                                value: selectedDevice,
                                                hint: const Text(
                                                    "Select thermal printer"),
                                                onChanged: (device) {
                                                  setState(() {
                                                    selectedDevice = device;
                                                  });
                                                },
                                                items: devices
                                                    .map((e) =>
                                                        DropdownMenuItem(
                                                          child: Text(e.name!),
                                                          value: e,
                                                        ))
                                                    .toList()),
                                          ),
                                          Container(
                                              margin: EdgeInsets.all(20),
                                              padding: EdgeInsets.all(20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colour.primary,
                                                      ),
                                                      onPressed: () {
                                                        printer.connect(
                                                            selectedDevice!);
                                                        Get.snackbar('Success',
                                                            'Printer connected successfully!');
                                                      },
                                                      child: Text(
                                                        "Connect",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colour.primary,
                                                      ),
                                                      onPressed: () {
                                                        printer.disconnect();
                                                        Get.snackbar('Success',
                                                            'Printer disconnected successfully!');
                                                      },
                                                      child: Text(
                                                        "Disconnect",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ],
                                              ))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Connect to Printer",
                                  style: TextStyle(color: Colors.black),
                                )))
                      ]),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: Colour.primary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) => queryProduk(query),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Image.asset(
                      'images/calendar.png',
                      width: 30,
                      height: 30,
                    )),
                Text('Filter by tanggal',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'All Transaksi',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: transaksiCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final List<DocumentSnapshot> transaksi = snapshot.data!.docs;

                  transaksiList = snapshot.data!.docs;

                  filterTransaksi();

                  if (filteredTransaksi.isEmpty) {
                    return Center(
                      child: Text(
                        'Transaksi tidak ditemukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTransaksi.length,
                    itemBuilder: (context, index) {
                      var transaksiData = filteredTransaksi[index].data()
                          as Map<String, dynamic>;
                      String namaPembeli = transaksiData['namaPembeli'];
                      String namaProduk = transaksiData['namaProduk'];
                      double hargaProduk =
                          transaksiData['hargaProduk']?.toDouble() ?? 0.0;
                      String formattedPrice =
                          currencyFormatter.format(hargaProduk);
                      int qty = transaksiData['qty'];
                      double uangBayar =
                          transaksiData['uangBayar']?.toDouble() ?? 0.0;
                      String formattedUangBayar =
                          currencyFormatter.format(uangBayar);
                      double totalBelanja =
                          transaksiData['totalBelanja']?.toDouble() ?? 0.0;
                      String formattedTotalBelanja =
                          currencyFormatter.format(totalBelanja);
                      double uangKembali =
                          transaksiData['uangKembali']?.toDouble() ?? 0.0;
                      String formattedUangKembali =
                          currencyFormatter.format(uangKembali);

                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(20),
                          height: 94,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('images/transaction.png'),
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      namaPembeli,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$namaProduk x $qty",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formattedTotalBelanja,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => TransaksiDetail(), arguments: {
                                    'id': filteredTransaksi[index].id,
                                    'namaPembeli': namaPembeli,
                                    'namaProduk': namaProduk,
                                    'qty': qty,
                                    'uangBayar': uangBayar,
                                    'totalBelanja': totalBelanja,
                                  });
                                },
                                icon: Icon(Icons.more_vert),
                                color: Colour.primary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colour.primary,
        onPressed: () async {
          await Get.to(() => TransaksiCreate());
          setState(() {});
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
