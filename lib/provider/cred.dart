import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zolatte_taskk/widgets.dart/alert_data_submitted.dart';

import '../core/redirect.dart';

class Cred with ChangeNotifier {
  final cred = FirebaseAuth.instance.currentUser!.email;
  bool dataFound = false;
  String? address;

  String? freeText;

  int? number;

  int? age;
  String country = CscCountry.India.toString();
  String? state;
  String? city;

  void setAge(int value) {
    age = value;
    notifyListeners();
  }

  Future checkData() async {
    try {
      //read data from database
      await FirebaseFirestore.instance
          .collection(cred!)
          .doc('user-detail')
          .get()
          .then((data) {
        address = data['address'];
        print(data['address']);
        number = data['number'];
        age = data['age'];
        freeText = data['free-text'];
        country = data['country'];
        state = data['state'];
        city = data['city'];
        dataFound = true;
      }).then((value) {});
    } catch (e) {
      print('errrror' + e.toString());
    }
  }

  void addData(BuildContext context) async {
    await FirebaseFirestore.instance.collection(cred!).doc('user-detail').set({
      'address': address,
      'number': number,
      'age': age,
      'free-text': freeText,
      'country': country,
      'state': state,
      'city': city,
    }).then((value) {
      notifyListeners();
      print('done');
    }).then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Submitted')));
    }).catchError((error) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('Failed, Try Again Later'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        }));

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void deleteData(BuildContext context) async {
    //delete task on database
    await FirebaseFirestore.instance
        .collection(cred!)
        .doc('user-detail')
        .delete()
        .then((value) {
      address = null;

      number = null;
      age = null;
      freeText = null;
      country = CscCountry.India.toString();
      state = null;
      city = null;
      dataFound = false;
      notifyListeners();
      Navigator.of(context).pushReplacementNamed(Redirect.routeName);
    });
  }
}
