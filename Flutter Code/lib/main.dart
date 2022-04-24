import 'package:flutter/material.dart';
import 'login_screen.dart';

/// Main Class
///
/// The Main class is responsible for starting the program with the
/// HomePage screen.

void main() => runApp(const MaterialApp(
  home: HomePage(),
));

@override

class AutoBuilder extends StatefulWidget {
  const AutoBuilder({Key? key}) : super(key: key);

  @override
  State<AutoBuilder> createState() => _AutoBuilderState();
}

class _AutoBuilderState extends State<AutoBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack());
  }
}


