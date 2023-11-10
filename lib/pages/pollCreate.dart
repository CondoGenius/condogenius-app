import 'package:condo_genius_beta/models/delivery_model.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(
        title: Text('Tela de Opções'),
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
                    // Imprima os valores dos TextFields
                    optionValues = [];
                    for (var textField in optionTextFields) {
                      optionValues.add(textField.controller.text);
                    }
                    print('Lista de Opções: $optionValues');
                  },
                  child: const Text('Obter Valores'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
