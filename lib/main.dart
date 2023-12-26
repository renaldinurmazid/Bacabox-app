import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/pages/admin/dashboard.dart';
import 'package:bacabox/pages/produk.dart';
import 'package:bacabox/pages/produk_create.dart';
import 'package:bacabox/pages/transaksi.dart';
import 'package:bacabox/pages/user.dart';
import 'package:bacabox/theme/color.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'pages/login.dart';
import 'pages/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => Screenpage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => MyHomePage()),
        GetPage(name: '/produk', page: () => ProdukPage()),
        GetPage(name: '/transaksi', page: () => TransaksiPage()),
        GetPage(name: '/users', page: () => UserPage()),
        GetPage(name: '/produkcreate', page: () => ProdukCreate()),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final List<Widget> _widgetOptions = <Widget>[
    DashboardAdmin(),
    TransaksiPage(),
    ProdukPage(),
    UserPage(),
  ];

  final RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _widgetOptions[_selectedIndex.value]),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colour.secondary,
        items: <Widget>[
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.swap_horizontal_circle, size: 30),
          Icon(Icons.book, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex.value,
      ),
    );
  }
}
