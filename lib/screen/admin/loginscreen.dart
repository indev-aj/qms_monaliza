import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qms_monaliza/screen/admin/adminscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String username = "";
  String password = "";

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0XFFDF7E14),
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 30),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('asset/img/logo.png'),
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: TextField(
                focusNode: _focusNode,
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ButtonTheme(
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Color(0XFFfd7e14),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => login(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    Map<dynamic, dynamic> map;
    username = usernameController.text;
    password = passwordController.text;

    databaseReference
        .child('operator')
        .once()
        .then((DataSnapshot dataSnapshot) {
      var data = dataSnapshot.value as Map;
      for (final key in data.keys) {
        map = data[key];

        if (username == map['username'] && password == map['password']) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminScreen()));
        }
      }
    });
  }
}
