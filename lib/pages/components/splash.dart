import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

Future<bool> isUserLoggedIn() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString('token');

  // Check if the token exists
  if (token != null) {
    // The user is logged in
    return true;
  } else {
    // The user is not logged in
    return false;
  }
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    isUserLoggedIn().then((logado) {
      if (logado) {
        Navigator.of(context).pushReplacementNamed('/Home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset("assets/condogenius.png"),
        ),
      ),
      splashIconSize: double.maxFinite,
      nextScreen: const Login(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
