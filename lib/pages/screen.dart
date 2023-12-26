import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screenpage extends StatelessWidget {
  const Screenpage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
    return Scaffold(
        body: Container(
            color: Colour.primary,
            child: Center(
                child: Container(
              width: 300,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('images/Bacabox.png'), width: 100),
                    Text(
                      "Bacabox",
                      style: TextStyle(
                          color: Colour.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 32),
                    )
                  ]),
            ))));
  }
}
