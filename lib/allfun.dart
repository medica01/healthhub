import 'package:flutter/cupertino.dart';

Widget text(String text, Color color, double size, FontWeight weight) {
  return Container(
    child: Text(
      text,
      textScaler: TextScaler.linear(1),
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    ),
  );
}