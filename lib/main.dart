import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zolatte_taskk/provider/cred.dart';
import 'package:zolatte_taskk/screens/delete_user_data.dart';
import 'package:zolatte_taskk/screens/homepage.dart';
import 'package:zolatte_taskk/screens/logout.dart';
import 'package:zolatte_taskk/screens/new_user_details.dart';
import 'package:zolatte_taskk/screens/number_login.dart';
import 'package:zolatte_taskk/screens/user_details.dart';

import 'core/redirect.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ZolatteTask());
}

class ZolatteTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cred(),
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromRGBO(114, 12, 217, 1),
                primary: Color.fromRGBO(114, 12, 217, 1)),
            textTheme: GoogleFonts.poppinsTextTheme(
              Typography.blackCupertino,
            )),
        home: Redirect(),
        routes: {
          NewUser.routeName: (context) => NewUser(),
          UserDetails.routeName: (context) => UserDetails(),
          LoginViaNumber.routeName: (context) => LoginViaNumber(),
          HomePage.routeName: (context) => HomePage(),
          Logout.routeName: (context) => Logout(),
          Redirect.routeName: (context) => Redirect(),
          DeleteData.routeName: (context) => DeleteData(),
        },
      ),
    );
  }
}
