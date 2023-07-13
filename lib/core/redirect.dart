import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zolatte_taskk/screens/homepage.dart';
import 'package:zolatte_taskk/screens/new_user_details.dart';

import 'package:zolatte_taskk/screens/user_details.dart';

import '../screens/login.dart';

class Redirect extends StatelessWidget {
  static const routeName = 'redirect';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              //if user loged in
              if (snap.hasData) {
                final user = FirebaseAuth.instance.currentUser;

                print(
                    'last signin ' + user!.metadata.lastSignInTime.toString());
                print('creation ' + user.metadata.creationTime.toString());
                if (user.phoneNumber == null) {
                  //if new user

                  return NewUser();
                } else {
                  return HomePage();
                }
              } else {
                //is user not found
                return LoginPage();
              }
            }));
  }
}
