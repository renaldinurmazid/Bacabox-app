import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/pages/dashboard.dart';
import 'package:bacabox/pages/log/log.dart';
import 'package:bacabox/pages/products/produk.dart';
import 'package:bacabox/pages/products/produk_create.dart';
import 'package:bacabox/pages/transactions/transaksi.dart';
import 'package:bacabox/pages/users/user.dart';
import 'package:bacabox/theme/color.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'pages/auth/login.dart';
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
        GetPage(name: '/log', page: () => Log()),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  final List<List<IconData>> _roleIcons = [
    [Icons.dashboard, Icons.person, Icons.book],
    [Icons.dashboard, Icons.swap_horizontal_circle],
    [Icons.dashboard, Icons.swap_horizontal_circle, Icons.history],
    [
      Icons.dashboard,
      Icons.swap_horizontal_circle,
      Icons.book,
      Icons.person,
      Icons.history
    ],
  ];

  final List<Widget> _adminOptions = <Widget>[
    Dashboard(),
    UserPage(),
    ProdukPage(),
  ];

  final List<Widget> _kasirOptions = <Widget>[
    Dashboard(),
    TransaksiPage(),
  ];

  final List<Widget> _ownerOptions = <Widget>[
    Dashboard(),
    TransaksiPage(),
    Log(),
  ];

  final List<Widget> _defaultOptions = <Widget>[
    Dashboard(),
    TransaksiPage(),
    ProdukPage(),
    UserPage(),
    Log(),
  ];

  final RxInt _selectedIndex = 0.obs;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> rolesOptions = [
      _adminOptions,
      _kasirOptions,
      _ownerOptions,
      _defaultOptions,
    ];

    return Scaffold(
      body: Obx(() {
        final int roleIndex = _authController.getCurrentUserRole().index;
        final List<Widget> selectedOptions = rolesOptions[roleIndex];
        return selectedOptions[_selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        final int roleIndex = _authController.getCurrentUserRole().index;
        final List<Widget> selectedOptions = rolesOptions[roleIndex];
        final List<IconData> selectedIcons = _roleIcons[roleIndex];
        return CurvedNavigationBar(
          backgroundColor: Colour.secondary,
          items: List.generate(selectedOptions.length, (index) {
            return Icon(selectedIcons[index], size: 30);
          }),
          onTap: _onItemTapped,
          index: _selectedIndex.value,
        );
      }),
    );
  }
}
