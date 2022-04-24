import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'data_entry_e_p.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

Widget _typer(){
  return SizedBox(
    width: 300.0,
    child: DefaultTextStyle(
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        onFinished: () {

        },
        animatedTexts: [
          TyperAnimatedText(
              'Welcome to Easy Lite',
            speed: Duration(milliseconds: 50)),
          TyperAnimatedText(
            'Your Solution For Home Automation',
            speed: Duration(milliseconds: 50)),
          TyperAnimatedText(
              "Let's Start by Getting to Know You",
              speed: Duration(milliseconds: 50)),
        ],
      )
    )
  );
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlue, Colors.white70])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                height: 200.0,
                width: 350.0,
                child: Center(
                  child: _typer(),
                ),
              ),
              DelayedDisplay(
                delay: Duration(seconds: 7),
                child: Container(
                  width: 300.0,
                  child: FadeTransition(
                    opacity: _animation,
                    child: RawMaterialButton(
                      fillColor: Colors.amber,
                      elevation: 0.0,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DataEntry()));
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                  ),
                ),
              ),
              ),
              ),
            ],
        ),
      ),
    );
  }
}
