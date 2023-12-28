import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';

class Log extends StatelessWidget {
  const Log({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.secondary,
      body: Center(
        child: Text("Log"),
      ),
    );
  }
}
