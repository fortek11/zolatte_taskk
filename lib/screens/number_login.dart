import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zolatte_taskk/screens/login_otp_form.dart';

import '../widgets.dart/login_alert_confirm_phone.dart';

class LoginViaNumber extends StatefulWidget {
  static const routeName = 'loginvianumber';
  @override
  State<LoginViaNumber> createState() => _LoginViaNumberState();
}

class _LoginViaNumberState extends State<LoginViaNumber> {
  bool passHiden = true;

  int? _number;
  bool _isLoading = false;

  String verify = '';

  final _key = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    void sendOtp() async {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: '+91${_number}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          verify = verificationId;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LoginOtpForm(verify);
          }));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Via Number'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Card(
            color: Colors.deepPurple,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              label: Text('Number'),
                              prefixText: '+91  ',
                            ),
                            validator: (value) {
                              if (value!.length != 10) {
                                return 'Number should be of 10 digits';
                              }
                              return null;
                            },
                            // obscureText: confirmPassHiden,
                            onChanged: (value) => _number = int.parse(value),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_number == null ||
                              _number.toString().length != 10 ||
                              _number == '' ||
                              _number == 0000000) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Enter a Valid Phone Number')));
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });

                          showDialog(
                              context: context,
                              builder: (context) =>
                                  LoginPhoneConfirmUpdate(_number!));
                        },
                        child: !_isLoading
                            ? Text("Submit",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold))
                            : CircularProgressIndicator(),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 100),
                            foregroundColor: Colors.deepPurple,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
