import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zolatte_taskk/screens/login_otp_form.dart';
import 'package:zolatte_taskk/screens/new_user_details.dart';

class LoginPhoneConfirmUpdate extends StatefulWidget {
  final int number;

  LoginPhoneConfirmUpdate(this.number);

  @override
  State<LoginPhoneConfirmUpdate> createState() =>
      _LoginPhoneConfirmUpdateState();
}

class _LoginPhoneConfirmUpdateState extends State<LoginPhoneConfirmUpdate> {
  String? verify;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    void sendOtp() async {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: '+91${widget.number}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          verify = verificationId;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LoginOtpForm(verify!);
          }));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }

    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 3.3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.question_mark_outlined,
                size: 45,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("Confirm Number ${widget.number} ?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 3.5,
            ),
            const Padding(
              padding: const EdgeInsets.all(12.0),
              child: const Text("OTP will be sent on this number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                  isLoading: _isLoading,
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    sendOtp();
                  },
                  primaryColor: primaryColor,
                  accentColor: Colors.white,
                ),
                //  SimpleBtn1(
                //       text: "Not bad",
                //       onPressed: () {
                //       },
                //       primaryColor: primaryColor,
                //       accentColor: Colors.white,
                //       invertedColors: true,
                //     ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final Color primaryColor;
  bool isLoading;

  final Function() onPressed;
  final bool invertedColors;
  final Color accentColor;
  SimpleBtn1(
      {required this.isLoading,
      required this.primaryColor,
      required this.onPressed,
      this.invertedColors = false,
      required this.accentColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: !isLoading
            ? Text(
                'OK',
                style: TextStyle(
                    color: invertedColors ? primaryColor : accentColor,
                    fontSize: 16),
              )
            : CircularProgressIndicator(
                color: Colors.white,
              ));
  }
}
