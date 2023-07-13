import 'package:flutter/material.dart';
import 'package:zolatte_taskk/screens/delete_user_data.dart';
import 'package:zolatte_taskk/screens/logout.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 150,
            padding: EdgeInsets.only(top: 80, bottom: 15, right: 80),
            child: Text(
              "Zolatte",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            )),
        Divider(),
        SizedBox(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.of(context).pushNamed(Logout.routeName),
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 218, 197, 255),
            maxRadius: 18,
            child: Icon(
              Icons.exit_to_app_rounded,
              color: Colors.deepPurple,
            ),
          ),
          title: Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 0,
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(DeleteData.routeName),
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 218, 197, 255),
            maxRadius: 18,
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.deepPurple,
            ),
          ),
          title: Text("Delete Data",
              style: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
