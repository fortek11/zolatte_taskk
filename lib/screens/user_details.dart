import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zolatte_taskk/screens/homepage.dart';

class UserDetails extends StatelessWidget {
  static const routeName = 'user-details';
  @override
  Widget build(BuildContext context) {
    final cred = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Details',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Card(
              elevation: 5,
              shadowColor: Colors.deepPurple,
              child: Image.network(cred!.photoURL ??
                  'https://cabexindia.com/wp-content/uploads/2023/02/no-image.jpg')),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Name: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 66, 18, 150)),
                ),
                Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(cred!.displayName!,
                        style: TextStyle(fontSize: 18))),
                Text(
                  "Email: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 66, 18, 150)),
                ),
                Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(cred!.email.toString(),
                        style: TextStyle(fontSize: 18))),
                Text(
                  " Number: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 66, 18, 150)),
                ),
                Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(cred.phoneNumber.toString(),
                        style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
            child: Text("Navigate Home", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 70)),
          ),
        ],
      ),
    );
  }
}
