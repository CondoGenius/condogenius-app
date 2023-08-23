import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        // TextField(
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //     hintText: 'Email',
                        //     labelText: 'Email',
                        //     hintStyle: TextStyle(fontSize: 16),
                        //     border: OutlineInputBorder(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(20)),
                        //       borderSide: BorderSide(
                        //         width: 0,
                        //         // style: BorderStyle.none,
                        //       ),
                        //     ),
                        //     filled: true,
                        //     contentPadding: EdgeInsets.all(10),
                        //   ),
                        // ),
                        PhysicalModel(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            autofocus: false,
                            decoration: InputDecoration(
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
                        SizedBox(
                          height: 20,
                        ),
                        PhysicalModel(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          child: TextField(
                            obscureText: true,
                            autofocus: false,
                            decoration: InputDecoration(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
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
                    child: const Text("Cadastre-se", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
