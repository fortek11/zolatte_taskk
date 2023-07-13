import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'alert_pass.dart';
import 'alert_pass_updated.dart';

class SetPassword extends StatefulWidget {
  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final _key = GlobalKey<FormState>();
  String password = '';
  String ConfirmPassword = '';
  bool passHiden = true;
  bool confirmPassHiden = true;
  bool passwordUpdated = false;
  @override
  Widget build(BuildContext context) {
    final userDetails = FirebaseAuth.instance.currentUser;

    void submitForm() async {
      //_key.currentState!.save();
      final _isValid = _key.currentState!.validate();
      if (!_isValid) {
        return;
      } else if ((password != ConfirmPassword)) {
        return showDialog(
            context: context, builder: (context) => PasswordAlert());
      }
      if (password == ConfirmPassword) {
        final emailCred = EmailAuthProvider.credential(
            email: '${userDetails!.email}', password: password);
        await userDetails.linkWithCredential(emailCred).then((value) {
          setState(() {
            passwordUpdated = true;
          });
          showDialog(context: context, builder: (context) => PasswordUpdated());
        });
      }
    }

    if (userDetails!.providerData
        .contains(EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD)) {
      setState(() {
        passwordUpdated == true;
      });
    }

    return !passwordUpdated
        ? Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "  Help Us Build Your Profile,",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    " Create Password:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          icon: passHiden
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              passHiden = !passHiden;
                            });
                          },
                        )),
                        obscureText: passHiden,
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'Pass should atleast be 8 characters';
                          }
                        },
                        onChanged: (value) => password = value,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    " Confirm Password:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          icon: confirmPassHiden
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              confirmPassHiden = !confirmPassHiden;
                            });
                          },
                        )),
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'Pass should atleast be 8 characters';
                          }
                        },
                        obscureText: confirmPassHiden,
                        onChanged: (value) => ConfirmPassword = value,
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerRight),
                          onPressed: () async {
                            if (password != ConfirmPassword) {
                              print('match: ' + password);
                            }

                            submitForm();
                          },
                          child: Text('Submit')),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Password Updated",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.done_rounded),
                )
              ],
            ),
          );
  }
}
