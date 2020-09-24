import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qms_monaliza/screen/admin/loginscreen.dart';

import 'package:get_mac/get_mac.dart';
import 'package:flutter/services.dart';
import '../../helper/storage.dart';
import '../../widgets/customWidgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  final Storage storage = Storage();
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  String _platformVersion = 'Unkown';

  int currentNumber;
  int lastNumber;
  int myNumber = 0;

  String _state;

  @override
  void initState() {
    if (!this.mounted) return;

    super.initState();

    WidgetsBinding.instance.addObserver(this);

    setState(() {
      getCurrentNumber();
    });

    databaseReference.child('number').onChildChanged.listen((Event event) {
      var data = event.snapshot;
      var key = data.key;

      setState(() {
        switch (key) {
          case 'currentNumber':
            currentNumber = data.value;
            if (currentNumber == 0) {
              setState(() {
                storage.deleteFile();
                myNumber = 0;
              });

              return;
            }

            if (myNumber == currentNumber) {
              databaseReference
                  .child('customer')
                  .once()
                  .then((DataSnapshot snapshot) {
                var data = snapshot.value as Map;

                data.forEach((key, value) {
                  if (_platformVersion == key) {
                    globalKey.currentState
                        .showSnackBar(snackBar(0XFFFFC107, "IT'S YOUR TURN"));
                    setState(() {
                      storage.deleteFile();
                      myNumber = 0;
                    });
                  }
                });
              });
            }

            break;
          default:
            break;
        }
      });
    });

    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        setState(() {
          _state = 'Paused';
          print(_state);
        });
        break;
      case AppLifecycleState.inactive:
        setState(() {
          _state = 'Inactive';
          print(_state);
        });
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _state = 'Resumed';
          print(_state);
        });
        break;
      case AppLifecycleState.detached:
        setState(() {
          _state = 'Detached';
          print(_state);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('QMS Monaliza'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.people),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())),
        ),
      ),
      body: Container(
        child: Center(
          child: currentNumber == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    title("CURRENT NUMBER"),
                    SizedBox(height: 10),
                    sub('$currentNumber'),
                    SizedBox(height: 35),
                    title("YOUR NUMBER"),
                    SizedBox(height: 10),
                    myNumber < 1 ? sub(' ') : sub('$myNumber'),
                    SizedBox(height: 50),
                    ButtonTheme(
                      height: 50,
                      minWidth: 200,
                      child: RaisedButton(
                        color: Color(0XFFfd7e14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () => getMyNumber(),
                        child: Text(
                          'Get Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// Get the latest number from DB
  /// 
  /// Only read local data if current number is greater than zero
  void getCurrentNumber() {
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        var data = snapshot.value;
        currentNumber = data['number']['currentNumber'];

        if (currentNumber > 0) {
          storage.readNumber().then((int value) {
            setState(() {
              myNumber = value;
            });
          });
        }
      });
    });
  }

  /// Get new number from DB
  void getMyNumber() {
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        var data = snapshot.value;
        lastNumber = data['number']['lastNumber'];

        myNumber = ++lastNumber;

        databaseReference.child('number').update({
          'lastNumber': lastNumber,
        });

        databaseReference.child('customer').update({
          _platformVersion: myNumber,
        });
      });

      storage.writeNumber(myNumber);
    });
  }

  /// Get MAC Address of the device
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Failed to get Device MAC Address';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
}
