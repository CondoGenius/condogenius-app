// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    double screenHeight = MediaQuery.of(context).size.height;

    double topPaddingPercentage = 10; // 10% da altura da tela
    double leftPaddingPercentage = 5; // 5% da largura da tela
    double rightPaddingPercentage = 5; // 5% da largura da tela
    double bottomPaddingPercentage = 15; // 15% da altura da tela

    EdgeInsetsGeometry padding = EdgeInsets.only(
      top: screenHeight * (topPaddingPercentage / 100),
      left: screenHeight * (leftPaddingPercentage / 100),
      right: screenHeight * (rightPaddingPercentage / 100),
      bottom: screenHeight * (bottomPaddingPercentage / 100),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: padding,
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

    final retunoLogin = await http.post(
      Uri.parse('http://192.168.1.74:5000/gateway/login'),
      body: {'email': _loginController.text, 'password': _senhaController.text},
    );

    var bodyLogin = jsonDecode(retunoLogin.body);

    if (retunoLogin.statusCode == 200) {
      String token = bodyLogin['token'];
      String email = bodyLogin['email'];
      int userId = bodyLogin['user_id'];
      int residentId = bodyLogin['resident_id'];
      await sharedPreferences.setString('token', token);
      await sharedPreferences.setString('email', email);
      await sharedPreferences.setInt('userId', userId);
      await sharedPreferences.setInt('residentId', residentId);

      final response = await http.get(
        Uri.parse(
            'http://192.168.1.74:5000/gateway/residents/api/residents/user/${userId.toString()}'),
        headers: {
          'x-access-token': token
        }, // Adicione o cabeçalho x-access-token aqui
      );

      var bodyDataUser = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await sharedPreferences.setInt(
            'residenceId', bodyDataUser['residence_id']);
      }

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
