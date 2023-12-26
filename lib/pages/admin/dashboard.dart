import 'package:bacabox/controller/authController.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardAdmin extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

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
            DashboardItem(
              title: 'Data Transaksi',
              iconPath: 'images/transaction.png',
              onPressed: () {
                // Tambahkan aksi saat tombol ditekan
              },
            ),
            SizedBox(height: 20),
            DashboardItem(
              title: 'Data Produk',
              iconPath: 'images/package.png',
              onPressed: () {
                // Tambahkan aksi saat tombol ditekan
              },
            ),
            SizedBox(height: 20),
            DashboardItem(
              title: 'Data Users',
              iconPath: 'images/user.png',
              onPressed: () {
                // Tambahkan aksi saat tombol ditekan
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
  final VoidCallback? onPressed;

  const DashboardItem({
    required this.title,
    required this.iconPath,
    this.onPressed,
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
                  "10",
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
          ElevatedButton(
            onPressed: onPressed,
            child: Text(
              "Show",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colour.primary),
              minimumSize: MaterialStateProperty.all(Size(60, 40)),
            ),
          ),
        ],
      ),
    );
  }
}
