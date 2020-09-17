import 'package:flutter/material.dart';
import 'package:qms_monaliza/screen/customer/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
          currentFocus.focusedChild.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QMS Monaliza',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Color(0XFFFD7E14)),
        ),
        home: HomeScreen()
      ),
    );
  }
}
