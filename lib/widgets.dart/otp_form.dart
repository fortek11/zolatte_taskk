import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:zolatte_taskk/screens/user_details.dart';

class OtpForm extends StatefulWidget {
  String verify;
  OtpForm(this.verify);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              'ENTER OTP',
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 47, 16, 100),
                  ),
                ),
                onChanged: (value) {
                  otpCode = value;
                },
                onCompleted: (value) {
                  otpCode = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  // Create a PhoneAuthCredential with the code
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verify, smsCode: otpCode!);

                  // Sign the user in (or link) with the credential
                  await auth.currentUser!
                      .linkWithCredential(credential)
                      .then((value) {
                    Navigator.of(context)
                        .pushReplacementNamed(UserDetails.routeName);
                  });
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: !_isLoading
                  ? Text("Submit", style: TextStyle(fontSize: 18))
                  : CircularProgressIndicator(
                      color: Colors.white,
                    ),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100)),
            ),
          ],
        ),
      ),
    );
  }
}
