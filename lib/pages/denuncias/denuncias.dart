import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/services/verifyLogin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Denuncias extends StatefulWidget {
  const Denuncias({super.key});

  @override
  State<Denuncias> createState() => _DenunciasState();
}

class _DenunciasState extends State<Denuncias> {
  final _denunciaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Menu(),
      appBar: AppBar(
        title: SizedBox(
          width: 100,
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HomePage()),
              // );
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'Reclamação',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          decorationColor: Colors.yellow,
                          decorationThickness: 5,
                          color: Colors.transparent, // Step 2 SEE HERE
                          shadows: [
                            Shadow(offset: Offset(0, -10), color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _denunciaController,
                              minLines: 15,
                              maxLines: 15,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 151, 151, 151),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 151, 151, 151),
                                      width: 2.0),
                                ),
                                filled: false,
                                hintText:
                                    'Descreva em detalhes o motivo da sua reclamação incluindo o nome ou casa do morador reclamado',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        saveDenuncia();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF2ABBAD)),
                      ),
                      child: const Text('Enviar Reclamação'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveDenuncia() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int? residentId = sharedPreferences.getInt('residentId');
    final int? residenceId = sharedPreferences.getInt('residenceId');
    const url = 'http://192.168.182.235:5000/gateway/api/complaints';
    // ignore: use_build_context_synchronously
    final dioErrorHandler = DioErrorHandler(context);

    await dioErrorHandler.handleDioError(() async {
      final response = await Dio().post(
        url,
        data: {
          'description': _denunciaController.text,
          'Status': 'Em análise',
          'resident_id': residentId,
          'residence_id': residenceId
        },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          headers: {
            'x-access-token': token
          }, // Adicione o cabeçalho x-access-token aqui
        ),
      );

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(
                255, 40, 112, 194), // Definindo o fundo como branco
            content: Center(
              child: Text(
                'Denúncia enviada com sucesso !',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255), // Definindo a cor do texto como preto (opcional)
                ),
              ),
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/Home');
      }
      return response;
    });
  }
}
