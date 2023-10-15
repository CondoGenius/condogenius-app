// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _senhaController = TextEditingController();
  final _loginController = TextEditingController();
  bool _erroEmail = false;
  bool _erroPassword = false;

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
                          shadowColor: _erroEmail ? Colors.red : Colors.black,
                          child: TextFormField(
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
                        if (_erroEmail)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Campo obrigatório',
                              style: TextStyle(color: Colors.red),
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
                          shadowColor:
                              _erroPassword ? Colors.red : Colors.black,
                          child: TextFormField(
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
                        if (_erroPassword)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Campo obrigatório',
                              style: TextStyle(color: Colors.red),
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
                      if (_loginController.text.isEmpty &&
                          _senhaController.text.isEmpty) {
                        _erroEmail = true;
                        _erroPassword = true;
                      } else {
                        _erroEmail = false;
                        _erroPassword = false;
                        logar();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 70),
                  InkWell(
                    onTap: () {
                      //navegar para a pagina register
                      Navigator.pushNamed(context, '/Register');
                    },
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

  // transferir para outro arquivo
  void logar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    const url = 'http://192.168.1.74:5000/gateway/login';

    final response = await Dio().post(url, data: {
      'email': _loginController.text,
      'password': _senhaController.text
    });

    if (response.statusCode == 200) {
      String token = response.data['token'];
      await sharedPreferences.setString('token', 'Token $token');
      await sharedPreferences.setString('email', _loginController.text);
      //ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:
              Color.fromARGB(255, 82, 82, 82), // Definindo o fundo como branco
          content: Center(
            child: Text(
              'Login Inválido !',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255,
                    255), // Definindo a cor do texto como preto (opcional)
              ),
            ),
          ),
        ),
      );
    }
  }
}
