import 'package:condo_genius_beta/pages/academia/academia.dart';
import 'package:condo_genius_beta/pages/components/splash.dart';
import 'package:condo_genius_beta/pages/denuncias/denuncias.dart';
import 'package:condo_genius_beta/pages/entrega/entrega.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:condo_genius_beta/pages/perfil/perfil.dart';
import 'package:condo_genius_beta/pages/register/register.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main()  {
  runApp(const CondoGenius());
}

class CondoGenius extends StatelessWidget {
  const CondoGenius({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CondoGenius',
      routes: {
        '/': (context) => const Splash(),
        '/Home': (context) => const HomePage(),
        '/Register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/Perfil':(context) => const Perfil(),
        '/Academia':(context) => const Academia(),
        '/Entrega':(context) => const Entrega(),
        '/Denuncias':(context) => const Denuncias()
      },
    );
  }
}
