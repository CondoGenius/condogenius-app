// ignore_for_file: avoid_print
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _senhaController = TextEditingController();
  final _loginController = TextEditingController();
  final _confirController = TextEditingController();
  bool _erroEmail = false;
  bool _erroPassword = false;
  bool _erroConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            top: 80,
            left: 40,
            right: 40,
            bottom: 30,
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
                        const SizedBox(
                          height: 20,
                        ),
                        PhysicalModel(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor:
                              _erroConfirmPassword ? Colors.red : Colors.black,
                          child: TextFormField(
                            controller: _confirController,
                            obscureText: true,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: 'Confirmar Senha',
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
                        if (_erroConfirmPassword)
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
                          _senhaController.text.isEmpty &&
                          _confirController.text.isEmpty) {
                        _erroEmail = true;
                        _erroPassword = true;
                        _erroConfirmPassword = true;
                      } else {
                        _erroEmail = false;
                        _erroPassword = false;
                        _erroConfirmPassword = false;
                        logar();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('REGISTRAR'),
                  ),
                  const SizedBox(height: 30),
                  // InkWell(
                  //   onTap: () {},
                  //   child: const Text("Esqueci minha senha >"),
                  // ),
                  // const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Voltar",
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
    const url = 'https://b543-45-188-17-163.ngrok-free.app/gateway/user/register';
    final dio = Dio();

    if (_senhaController.text != _confirController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:
              Color.fromARGB(255, 82, 82, 82), // Definindo o fundo como branco
          content: Center(
            child: Text(
              'As senhas não conferem !',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255,
                    255), // Definindo a cor do texto como preto (opcional)
              ),
            ),
          ),
        ),
      );
      return;
    }

    try {
      final response = await dio.post(
        url,
        data: {
          'email': _loginController.text,
          'password': _senhaController.text,
          'role_id': 1
        },
        options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            validateStatus: (_) => true),
      );

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(
                255, 40, 112, 194), // Definindo o fundo como branco
            content: Center(
              child: Text(
                'Usuário cadastrado com sucesso !',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255), // Definindo a cor do texto como preto (opcional)
                ),
              ),
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else if (response.statusCode == 400) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(
                255, 82, 82, 82), // Definindo o fundo como branco
            content: Center(
              child: Text(
                response.data['error'].toString(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255), // Definindo a cor do texto como preto (opcional)
                ),
              ),
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(
                255, 82, 82, 82), // Definindo o fundo como branco
            content: Center(
              child: Text(
                'Não foi possivel cadastrar o usuário !',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255), // Definindo a cor do texto como preto (opcional)
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:
              Color.fromARGB(255, 82, 82, 82), // Definindo o fundo como branco
          content: Center(
            child: Text(
              'Não foi possivel cadastrar o usuário !',
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
