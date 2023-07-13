import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zolatte_taskk/core/redirect.dart';

import '../provider/cred.dart';

class DeleteData extends StatelessWidget {
  static const routeName = 'deletedata';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Cred>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete User Data"),
      ),
      body: Center(
        child: Card(
          color: Colors.deepPurple,
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.all(20),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Do You Want to Delete Your Data?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider.deleteData(context);
                    },
                    child: Text("Confirm Delete",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                        foregroundColor: Colors.deepPurple,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
