import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/controller/bookController.dart';
import 'package:bacabox/controller/transaksiController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController _authController = Get.find<AuthController>();
  final BookController _bookController = Get.put(BookController());
  final AuthController _userController = Get.put(AuthController());
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());

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
                'Dashboard',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  _authController.signOut();
                  printer.disconnect();
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _transaksiController.countTransaksi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int transaksiCount = snapshot.data ?? 0;
                  return DashboardItem(
                    title: 'Data Transaksi',
                    iconPath: 'images/transaction.png',
                    dataCount: transaksiCount,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _bookController.countProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int bookCount = snapshot.data ?? 0;
                  return DashboardItem(
                    title: 'Data Produk',
                    iconPath: 'images/package.png',
                    dataCount: bookCount,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _userController.countUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int usersCount = snapshot.data ?? 0;
                  return DashboardItem(
                    title: 'Data Users',
                    iconPath: 'images/user.png',
                    dataCount: usersCount,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final int dataCount;

  const DashboardItem({
    required this.title,
    required this.iconPath,
    required this.dataCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            image: AssetImage(iconPath),
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
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dataCount.toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
