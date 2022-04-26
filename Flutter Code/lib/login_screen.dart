import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_project/primary_screen.dart';
import 'package:first_flutter_project/sign_up_screen.dart';
import 'package:flutter/material.dart';

/// HomePage Screen
///
/// The HomePage screen is responsible as acting as the initial startup
/// screen for the application. Users will have the option to login or
/// create a new account here.


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Firebase Initialization
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Attempts to log the user into the program using Firebase Authentication
  /// Uses email and password combination
  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        print(e.code);
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Stack(
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
              Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.png'),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      const SizedBox(height: 180),
                      Container(
                          height: 240,
                          width: 375,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.black),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 140),
                      const SizedBox(height: 10),
                      Container(
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen.shade700,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                          )
                        ),
                        child: Row(
                          children: const [
                            SizedBox(width: 18),
                            Text("Login to Get Started",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 190),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "email",
                        prefixIcon: Icon(Icons.person, color: Colors.grey.shade800),
                      ),
                    ),
                    const SizedBox(height:15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:  InputDecoration(
                        hintText: "password",
                        prefixIcon: Icon(Icons.key, color: Colors.grey.shade800),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 45,
                      width: 200,
                      child: RawMaterialButton(
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
                          if(user != null) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PrimaryScreen()));
                          }
                          else {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                    title: Text("Login Failed"),
                                    content: Text("Username not Found")
                                )
                            );
                          }
                        },
                        fillColor: Colors.yellow,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: const Text("Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height:420),
                  Row(
                    children: [
                      const SizedBox(width:10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
                        },
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                      const Text(" - "),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          "Recover Your Password",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          );
  }
}