import 'dart:convert';
import 'package:condo_genius_beta/models/academic_ability.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Academia extends StatefulWidget {
  const Academia({super.key});

  @override
  State<Academia> createState() => _AcademiaState();
}

Future<AcademicAbility> getAcademic() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString('token');

  final response = await http.get(
    Uri.parse('http://192.168.1.74:5000/gateway/api/checks/active'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token ?? '',
    },
  );


  if (response.statusCode == 200) {
    // Use a função fromJson para converter o JSON em uma instância da classe modelo
    return AcademicAbility.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    throw Exception('Login Expirado');
  } else {
    throw Exception('Falha ao carregar dados da API');
  }
}

class _AcademiaState extends State<Academia> {
  late Future<String?> _checkin;
  late Future<AcademicAbility> _checkinAcademic;
  late String? residentName;

  @override
  void initState() {
    super.initState();
    _checkin = getCheckin();
    _checkinAcademic = getAcademic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Menu(),
      appBar: AppBar(
        title: SizedBox(
          width: 100,
          child: GestureDetector(
            onTap: () {
              // Navegue para a página desejada quando o título for pressionado.
              // Por exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
              onPressed: () {
                // Navegue de volta para a página anterior.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
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
      body: FutureBuilder<String?>(
        future: _checkin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            bool checked = snapshot.data != null;

            return SingleChildScrollView(
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
                            padding: EdgeInsets.only(top: 30, bottom: 30),
                            child: Text(
                              'Check-in/Check-out Academia',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                decorationColor: Colors.yellow,
                                decorationThickness: 5,
                                color: Colors.transparent,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, -10),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FutureBuilder<AcademicAbility>(
                              // Chame a função getAcademic aqui
                              future: getAcademic(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Exibição enquanto os dados estão sendo carregados
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // Exibição em caso de erro
                                  return Text('Erro: ${snapshot.error}');
                                } else {
                                  // Exibição do valor retornado da API
                                  return Column(
                                    children: [
                                      const Icon(Icons.group,
                                          color:
                                              Color.fromARGB(255, 90, 90, 90)),
                                      Text(
                                          '${snapshot.data?.activeCheckIns ?? 0}/${snapshot.data?.capacity} check-in(s) até o momento'),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    residentName!.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/garoto.png',
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 10),
                                  child: Text(
                                    'Local: Academia',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FutureBuilder<AcademicAbility>(
                                    future: getAcademic(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Erro: ${snapshot.error}');
                                      } else {
                                        bool isButtonDisabled =
                                            snapshot.data?.activeCheckIns ==
                                                snapshot.data?.capacity;

                                        return Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    isButtonDisabled
                                                        ? Colors.grey
                                                        : (checked
                                                            ? Colors.red
                                                            : Colors.green),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: isButtonDisabled
                                                  ? null // Button is disabled if the condition is true
                                                  : () async {
                                                      if (checked) {
                                                        await removeCheckin();
                                                      } else {
                                                        await addCheckin();
                                                      }
                                                    },
                                              child: Text(
                                                checked
                                                    ? (isButtonDisabled
                                                        ? 'CHECK-IN'
                                                        : 'CHECK-OUT')
                                                    : 'CHECK-IN',
                                              ),
                                            ),
                                            Text(
                                              isButtonDisabled
                                                  ? 'Limite máximo de pessoas atingido'
                                                  : '',
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String?> getCheckin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int? residentId = sharedPreferences.getInt('residentId');
    residentName = sharedPreferences.getString('name');

    final dio = Dio();
    const url = 'http://192.168.1.74:5000/gateway/api/checks/resident/';

    final response = await dio.get(
      '$url$residentId',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        headers: {'x-access-token': token},
      ),
    );

    // Verifique se a solicitação foi bem-sucedida antes de retornar a resposta.
    if (response.statusCode == 200) {
      return response.data.toString();
    } else {
      // Lida com o erro de acordo com sua lógica
      return null;
    }
  }

  Future<void> removeCheckin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int? residentId = sharedPreferences.getInt('residentId');
    const url = 'http://192.168.1.74:5000/gateway/api/checks';

    final response = await Dio().delete(
      url,
      data: {
        'resident_id': residentId,
      },
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        headers: {'x-access-token': token},
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Atualize os dados ou recarregue a lista aqui
        _checkin = getCheckin();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(
              255, 40, 112, 194), // Definindo o fundo como branco
          content: Center(
            child: Text(
              response.data,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255) // Definindo a cor do texto como preto (opcional)
                  ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> addCheckin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int? residentId = sharedPreferences.getInt('residentId');
    const url = 'http://192.168.1.74:5000/gateway/api/checks';

    final response = await Dio().post(
      url,
      data: {
        'resident_id': residentId,
      },
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        headers: {'x-access-token': token},
      ),
    );

    if (response.statusCode == 201) {
      setState(() {
        // Atualize os dados ou recarregue a lista aqui
        _checkin = getCheckin();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(
              255, 40, 112, 194), // Definindo o fundo como branco
          content: Center(
            child: Text(
              response.data,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255,
                      255) // Definindo a cor do texto como preto (opcional)
                  ),
            ),
          ),
        ),
      );
    }
  }
}
