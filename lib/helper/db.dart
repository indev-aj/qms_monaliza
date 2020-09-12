import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DBHelper extends StatefulWidget {
  @override
  _DBHelperState createState() => _DBHelperState();
}

class _DBHelperState extends State<DBHelper> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  void getMyNumber(int lastNumber, int myNumber, _platformVersion, storage) {
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

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
