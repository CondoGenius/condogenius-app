import 'dart:convert';

import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PollCreate extends StatefulWidget {
  const PollCreate({super.key});

  @override
  State<PollCreate> createState() => _PollCreateState();
}

class _PollCreateState extends State<PollCreate> {
  TextEditingController titleController = TextEditingController();
  List<OptionTextField> optionTextFields = [];
  List<String> optionValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Menu(),
      appBar: AppBar(
        title: SizedBox(
          width: 100,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: Image.asset('assets/condogenius.png'),
          ),
        ),
        toolbarHeight: 90,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        actions: [
          Builder(
            builder: (context) => IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(12, 192, 223, 1),
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )
              },
            ),
          ),
          const SizedBox(width: 10),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu,
                  color: Color.fromARGB(255, 90, 90, 90)),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opções:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(optionTextFields.length, (index) {
                    TextEditingController optionController =
                        TextEditingController(); // Novo controlador para cada TextField
                    optionTextFields[index] = OptionTextField(
                      index: index,
                      onRemove: () {
                        setState(() {
                          optionTextFields.removeAt(index);
                        });
                      },
                      controller: optionController,
                    );
                    return optionTextFields[index];
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      TextEditingController optionController =
                          TextEditingController();
                      optionTextFields.add(OptionTextField(
                        index: optionTextFields.length,
                        onRemove: () {
                          setState(() {
                            optionTextFields.removeLast();
                          });
                        },
                        controller: optionController,
                      ));
                    });
                  },
                  child: const Text('Adicionar Opção'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var isEmpty = verifyEmptyFields(optionTextFields);

                    if (isEmpty || optionTextFields.isEmpty) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(
                              255, 82, 82, 82), // Definindo o fundo como branco
                          content: Center(
                            child: Text(
                              'Preencha todos os campos!',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Definindo a cor do texto como preto (opcional)
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                       savePoll();
                    }
                  },
                  child: const Text('SALVAR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool verifyEmptyFields(List<OptionTextField> optionTextFields) {
    bool isEmpty = false;

    for (var textField in optionTextFields) {
      if (textField.controller.text == '') {
        isEmpty = true;
      }
    }

    return isEmpty;
  }

  Future<void> savePoll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int userId = sharedPreferences.getInt('userId')!;

    optionValues = [];

    for (var textField in optionTextFields) {
      optionValues.add(textField.controller.text);
    }

    final response = await http.post(
      Uri.parse('https://b543-45-188-17-163.ngrok-free.app/gateway/hub_digital/api/poll'),
      headers: {
        'Content-type': 'application/json',
        'x-access-token': token.toString(),
      },
      body: jsonEncode({
        "content": titleController.text,
        "user_id": userId,
        "options": optionValues
      }),
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(
              255, 40, 112, 194), // Definindo o fundo como branco
          content: Center(
            child: Text(
              body['message'].toString(),
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255,
                    255), // Definindo a cor do texto como preto (opcional)
              ),
            ),
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/Home');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:
              Color.fromARGB(255, 82, 82, 82), // Definindo o fundo como branco
          content: Center(
            child: Text(
              'Erro ao criar a enquete!',
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

class OptionTextField extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;
  final TextEditingController controller;

  OptionTextField(
      {required this.index, required this.onRemove, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Opção',
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
