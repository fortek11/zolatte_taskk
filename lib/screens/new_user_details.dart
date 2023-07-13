import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zolatte_taskk/widgets.dart/create_phone_alert.dart';
import 'package:zolatte_taskk/widgets.dart/login_alert_confirm_phone.dart';
import 'package:zolatte_taskk/widgets.dart/otp_form.dart';

import 'package:zolatte_taskk/widgets.dart/set_password.dart';

class NewUser extends StatefulWidget {
  static const routeName = 'newuser';

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  bool isLoading = false;
  String verify = '';
  int? phoneNumber = 0000000;
  Widget build(BuildContext context) {
    final userDetails = FirebaseAuth.instance.currentUser;
    void sendOtp() async {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: '+91${phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          verify = verificationId;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return OtpForm(verify);
          }));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              Text('${userDetails!.displayName},',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Card(
                    elevation: 4,
                    color: Color.fromRGBO(114, 12, 217, 1),
                    child: SetPassword()),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Card(
                    elevation: 4,
                    color: Color.fromRGBO(114, 12, 217, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Validate Phone Number",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixText: '+91  ',
                                ),
                                validator: (value) {
                                  if (value!.length < 8) {
                                    return 'Pass should atleast be 8 characters';
                                  }
                                  return null;
                                },
                                // obscureText: confirmPassHiden,
                                onChanged: (value) =>
                                    phoneNumber = int.parse(value),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                alignment: Alignment.centerRight),
                            onPressed: () async {
                              if (phoneNumber == null ||
                                  phoneNumber.toString().length != 10 ||
                                  phoneNumber == '' ||
                                  phoneNumber == 0000000) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Enter a Valid Phone Number')));
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });

                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CreatePhoneConfirmUpdate(phoneNumber!));
                            },
                            child: !isLoading
                                ? Text('Submit')
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
