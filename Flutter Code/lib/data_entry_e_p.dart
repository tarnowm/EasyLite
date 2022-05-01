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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset('assets/wall_green.png',
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Column(
                children: [
                  const SizedBox(height: 120),
                  Container(
                    height: 290,
                    width: 355,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width:20),
              Column(
                children: [
                  const SizedBox(height:90),
                  Container(
                    height: 30,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade700,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children:  [
                        SizedBox(width: 18),
                        Column(
                          children: [
                            SizedBox(height:5 ),
                            Text("Account Creation",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 25),
              Column(
                children: [
                  SizedBox(height: 130),
                  Container(
                    width: 345,
                    child: TextField(
                      controller: _firstName,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "first name",
                        prefixIcon: Icon(Icons.sort_by_alpha_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 345,
                    child: TextField(
                      controller: _lastName,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "last name",
                        prefixIcon: Icon(Icons.sort_by_alpha_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 345,
                    child: TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "email",
                        prefixIcon: Icon(Icons.email_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 345,
                    child: TextField(
                      controller: _password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: "password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 345,
                    child: TextField(
                      controller: _pwrRate,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "kWh rate (optional)",
                        prefixIcon: Icon(Icons.bolt, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 100),

              Column(
                children: [
                  SizedBox(height: 420),
                  Container(
                    width: 200,
                    height: 50,
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
                    )
                  ),
                  ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
