// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _senhaController = TextEditingController();
  final _loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            top: 100,
            left: 40,
            right: 40,
            bottom: 90,
          ),
          color: const Color.fromRGBO(12, 192, 223, 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset("assets/condogenius.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        PhysicalModel(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          child: TextField(
                            controller: _loginController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              fillColor: Colors.white,
                              filled: false,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PhysicalModel(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          child: TextField(
                            controller: _senhaController,
                            obscureText: true,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Senha',
                              fillColor: Colors.white,
                              filled: false,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(12, 192, 223, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      logar();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const HomePage()),
                      // );
                    },
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 70),
                  // InkWell(
                  //   onTap: () {},
                  //   child: const Text("Esqueci minha senha >"),
                  // ),
                  // const SizedBox(height: 10),
                  InkWell(
                    onTap: () {},
                    child: const Text("Cadastre-se",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var body = json.encode(
        {'User': _loginController.text, 'Password': _senhaController.text});

    var url = Uri.parse('http://192.168.1.74:5000/api/auth/login');
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: body);

    if (response.statusCode == 200) {
      String token = json.decode(response.body)['jwtToken'];
      String name = json.decode(response.body)['user'];
      await sharedPreferences.setString('token', 'Token $token');
      await sharedPreferences.setString('user', name);
      //ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Inválido !'),
        ),
      );
    }
  }
}
