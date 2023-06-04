// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class DeviderWidget extends StatelessWidget {
  const DeviderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myColor1 = Color(0xff573353);
    final myColor2 = Color(0xFFFC9D45);
    return Divider(
      height: 1.0,
      color: myColor2,
      thickness: 3.0,
    );
  }
}
