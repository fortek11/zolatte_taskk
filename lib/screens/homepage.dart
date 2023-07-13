import 'package:csc_picker/csc_picker.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zolatte_taskk/provider/cred.dart';
import 'package:zolatte_taskk/screens/user_details.dart';
import 'package:zolatte_taskk/widgets.dart/drawer.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'homepage';

  final _key = GlobalKey<FormState>();

  final cred = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Cred>(context);

    void submitData() {
      final validate = _key.currentState!.validate();
      if (!validate) {
        return;
      }

      if (provider.country == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Select a country")));
        return;
      }
      if (provider.state == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Select a state")));
        return;
      }
      if (provider.city == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Select a city")));
        return;
      }
      if (provider.age == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Select an age")));
        return;
      }
      provider.addData(context);
    }

    List<int> ageList = List<int>.generate(80, (int index) => index + 1);

    List<DropdownMenuItem> menuItemList = ageList
        .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
        .toList();
    return Scaffold(
        drawer: Drawer(
          child: MainDrawer(),
        ),
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(UserDetails.routeName);
                },
                icon: Icon(Icons.account_circle_outlined))
          ],
        ),
        body: FutureBuilder(
            future: provider.checkData(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Stack(children: [
                        Form(
                            key: _key,
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        if (value.length < 10) {
                                          return 'Address should be atleast 10 characters';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) =>
                                          provider.address = value,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.multiline,
                                      readOnly: provider.dataFound,
                                      key: Key(provider.address.toString()),
                                      initialValue: provider.address,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          labelText: 'Address'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CSCPicker(
                                      defaultCountry: CscCountry.India,
                                      disableCountry: true,
                                      onCountryChanged: (value) {
                                        provider.country = value;
                                      },
                                      onStateChanged: (value) {
                                        provider.state = value;
                                      },
                                      onCityChanged: (value) {
                                        provider.city = value;
                                      },
                                      searchBarRadius: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: TextFormField(
                                      readOnly: provider.dataFound,
                                      key: Key(provider.number.toString()),
                                      initialValue: provider.number == null
                                          ? ''
                                          : provider.number.toString(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a number';
                                        }
                                        if (value.length != 10) {
                                          return 'Number should be of 10 digits';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) =>
                                          provider.number = int.parse(value),
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          labelText: 'Number'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                            onChanged: (value) =>
                                                provider.freeText = value,
                                            readOnly: provider.dataFound,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                            key: Key(
                                                provider.freeText.toString()),
                                            initialValue:
                                                provider.freeText ?? '',
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                labelText: 'Write Something'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey)),
                                          child: DropdownButton(
                                              hint: Text("Age "),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.deepPurple,
                                              ),
                                              icon: Icon(
                                                Icons
                                                    .arrow_drop_down_circle_outlined,
                                                color: Colors.deepPurple,
                                              ),
                                              value: provider.age,
                                              items: menuItemList,
                                              onChanged: (value) {
                                                provider.setAge(value);
                                              }),
                                        )
                                      ],
                                    ),
                                  )
                                ]))),
                        if (provider.dataFound)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: _key.currentContext == null
                                ? 10
                                : (_key.currentContext!.findRenderObject()
                                        as RenderBox)
                                    .size
                                    .height,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!provider.dataFound) {
                            submitData();
                          } else {
                            null;
                          }
                        },
                        child: Text(
                            !provider.dataFound ? "Submit" : "Data Submitted",
                            style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            foregroundColor: Colors.white,
                            backgroundColor: !provider.dataFound
                                ? Colors.deepPurple
                                : Color.fromARGB(255, 148, 142, 157),
                            padding: !provider.dataFound
                                ? EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 100)
                                : EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 70)),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
