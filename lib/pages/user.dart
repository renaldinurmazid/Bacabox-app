import 'package:bacabox/pages/transaksi_create.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.secondary,
      appBar: AppBar(
        backgroundColor: Colour.secondary,
        title: Center(
          child: Text(
            'Users',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
            ),
            SizedBox(height: 20),
            Text(
              'All Users',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/user.png'),
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
                          "Renaldi Nurmazid",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "renaldinurmazid@gmail.com",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                    color: Colour.primary,
                    iconSize: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colour.primary,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
