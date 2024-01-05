import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/controller/bookController.dart';
import 'package:bacabox/controller/logController.dart';
import 'package:bacabox/controller/transaksiController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController _authController = Get.find<AuthController>();
  final BookController _bookController = Get.put(BookController());
  final AuthController _userController = Get.put(AuthController());
  final LogController _logController = Get.put(LogController());
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
    UserRole currentUserRole = _authController.getCurrentUserRole();
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
        child: ListView(
          children: [
            if (currentUserRole == UserRole.Kasir) ...[
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
            ],
            if (currentUserRole == UserRole.Owner) ...[
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
                future: _logController.countLog(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int logCount = snapshot.data ?? 0;
                    return DashboardItem(
                      title: 'Data Log',
                      iconPath: 'images/history.png',
                      dataCount: logCount,
                    );
                  }
                },
              ),
            ],
            if (currentUserRole == UserRole.Admin) ...[
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
            ],
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chart Income",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            DashboardChart(),
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

class DashboardChart extends StatefulWidget {
  @override
  _DashboardChartState createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  late List<DocumentSnapshot> firebaseData = [];

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  String formatCurrency(double number) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(number);
  }

  Future<void> getDataFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('transaksi').get();
    setState(() {
      firebaseData = querySnapshot.docs;
    });
  }

  Map<String, double> calculateMonthlyIncome() {
    Map<String, double> monthlyIncome = {};

    for (var transaction in firebaseData) {
      String tanggal = transaction['created_at'];
      double totalBelanja = transaction['totalBelanja'];

      DateTime date = DateTime.parse(tanggal);
      String bulanTahunKey = '${date.year}-${date.month}';

      if (monthlyIncome.containsKey(bulanTahunKey)) {
        monthlyIncome[bulanTahunKey] =
            monthlyIncome[bulanTahunKey]! + totalBelanja;
      } else {
        monthlyIncome[bulanTahunKey] = totalBelanja.toDouble();
      }
    }

    return monthlyIncome;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> monthlyIncomeData = calculateMonthlyIncome();
    return Container(
      height: 400,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<MapEntry<String, double>, String>(
            dataSource: monthlyIncomeData.entries.toList(),
            xValueMapper: (MapEntry<String, double> sales, _) => sales.key,
            yValueMapper: (MapEntry<String, double> sales, _) => sales.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
            ),
            dataLabelMapper: (MapEntry<String, double> sales, _) {
              return formatCurrency(sales.value);
            },
          ),
        ],
      ),
    );
  }
}
