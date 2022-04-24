import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/primary_screen.dart';
import 'package:flutter/material.dart';

/// Data Entry Screen
///
/// This screen is responsible for collecting data from new users via
/// text field inputs. The information is saved to FireStore.

class DataEntry extends StatefulWidget {
  const DataEntry({Key? key}) : super(key: key);

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {

  static Future<User?> createUserWithEmailPassword({required String email, required String password, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _firstName = TextEditingController();
    TextEditingController _lastName = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    TextEditingController _pwrRate = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.white70])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          elevation: 0.0,
          shadowColor: Colors.blueGrey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: const Text(
            'Account Creation',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _firstName,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "first name",
                    prefixIcon: Icon(Icons.sort_by_alpha_rounded, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 9.0,
                ),
                TextField(
                  controller: _lastName,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "last name",
                    prefixIcon: Icon(Icons.sort_by_alpha_rounded, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 9.0,
                ),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "email",
                    prefixIcon: Icon(Icons.email_rounded, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: "password",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _pwrRate,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "kWh rate (optional)",
                    prefixIcon: Icon(Icons.bolt, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Container(
                  width: 200.0,
                  height: 50.0,
                  child: RawMaterialButton(
                    onPressed: () async {
                     User? user = await createUserWithEmailPassword(email: _email.text, password: _password.text, context: context);
                     FirebaseFirestore.instance.collection('users').add({
                       'first name': _firstName.text,
                       'last name': _lastName.text,
                       'email': _email.text,
                       'kWh': _pwrRate.text,
                     });
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PrimaryScreen()));
                     //print(user);
                     },
                    fillColor: Colors.amber,
                    elevation: 1.0,
                    hoverColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                  ),
                ),
                ),
            ],
        ),
      ),
      ),
    );
  }
}
