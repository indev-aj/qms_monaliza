import 'package:flutter/material.dart';

Text title(String msg) {
  return Text(
    msg,
    style: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text sub(String msg) {
  return Text(
    msg,
    style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );
}

SnackBar snackBar(int color, String msg) {
  return SnackBar(
    backgroundColor: Color(color),
    duration: Duration(seconds: 3),
    content: Container(
      height: 40,
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
