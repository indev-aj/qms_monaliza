import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qms_monaliza/screen/customer/homescreen.dart';
import 'package:qms_monaliza/widgets/customWidgets.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  int currentNumber;
  int lastNumber;

  @override
  void initState() {
    if (!this.mounted) return;

    setState(() {
      getCurrentNumber();
    });

    databaseReference.child('number').onChildChanged.listen((Event event) {
      var data = event.snapshot;
      var key = data.key;

      if (!this.mounted) return;

      setState(() {
        switch (key) {
          case 'currentNumber':
            currentNumber = data.value;
            break;
          default:
            break;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('QMS Monaliza'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Prompt for log out
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title("CURRENT NUMBER"),
              SizedBox(height: 10),
              sub('$currentNumber'),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button('NEXT'),
                  SizedBox(width: 30),
                  button('RESET'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentNumber() {
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        var data = snapshot.value;
        currentNumber = data['number']['currentNumber'];
        lastNumber = data['number']['lastNumber'];
      });
    });
  }

  ButtonTheme button(String text) {
    return ButtonTheme(
      height: 50,
      minWidth: 100,
      child: RaisedButton(
        color: Color(0XFFFD7E14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          switch (text) {
            case 'RESET':
              // Reset counter
              _showMyDialog();
              break;
            case 'NEXT':
              getCurrentNumber();

              if (currentNumber < lastNumber) {
                setState(() {
                  currentNumber += 1;
                });
              }

              databaseReference.child('number').update({
                'currentNumber': currentNumber,
              });
              break;
            default:
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ALERT"),
          content: Text('Reset Counter?'),
          actions: [
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                databaseReference.child('number').update({
                  'currentNumber': 0,
                  'lastNumber': 0,
                });
                databaseReference.child('customer').remove();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
