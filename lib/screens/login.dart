import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zolatte_taskk/screens/number_login.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passHiden = true;
  final _key = GlobalKey<FormState>();
  // bool _createAccount = false;
  void submitForm() async {
    final _isValid = _key.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _key.currentState!.save();

    try {
      final _credentials = await _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      print(_credentials);
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Failed, Try Again')));
    }
    try {
      final _credentials = await _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      print(_credentials);
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Failed, Try Again')));
    }
  }

  bool _isLoading = false;

  var _email = '';
  var _pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Image.asset('assets/zoll.png', fit: BoxFit.fill),
              Card(
                color: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Login',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(114, 12, 217, 1))),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                            validator: (value) {
                              //validate on save
                              if (value == null || value.isEmpty) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            autofocus: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email'),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid PassWord';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _pass = newValue!;
                            },
                            //hide passowrd
                            obscureText: passHiden,
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: passHiden
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      passHiden = !passHiden;
                                    });
                                  },
                                ),
                                labelText: 'Password'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              submitForm();
                            },
                            child: Text("Submit",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 100),
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromRGBO(114, 12, 217, 1),
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
              const SizedBox(
                height: 10,
              ),
              const Divider(
                indent: 60,
                endIndent: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginViaNumber.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 20,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      foregroundColor: Colors.deepPurple,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                          borderRadius: BorderRadius.circular(5))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 85),
                    child: Text('Login Via Number'),
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final GoogleSignInAccount? gUser =
                        await GoogleSignIn().signIn();
                    //obtain auth details
                    final GoogleSignInAuthentication gAuth =
                        await gUser!.authentication;

                    //create new cred
                    final cred = GoogleAuthProvider.credential(
                      accessToken: gAuth.accessToken,
                      idToken: gAuth.idToken,
                    );

                    await FirebaseAuth.instance.signInWithCredential(cred);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 20,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      foregroundColor: Colors.white,
                      backgroundColor: _isLoading
                          ? Colors.white
                          : const Color.fromARGB(255, 63, 22, 134),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: !_isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                child: Image.asset('assets/google.png'),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const Text('Continue With Google'),
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: 200,
                          child: LinearProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
