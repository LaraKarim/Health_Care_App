import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Color.fromARGB(255, 33, 240, 243)),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
    ),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 18),
    ),
  );
  static final ButtonStyle elevatedButtonStylehome = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Color.fromARGB(255, 33, 240, 243)),
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 255, 152, 0), // Change text color to black
      ),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
    ),
  );

  static final ButtonStyle textButtonStyle = ButtonStyle(
    textStyle: MaterialStateProperty.all(
      const TextStyle(color: Color.fromARGB(255, 226, 11, 11)),
    ),
  );
}
