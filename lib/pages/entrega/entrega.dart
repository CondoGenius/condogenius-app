import 'package:condo_genius_beta/models/delivery_model.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Entrega extends StatefulWidget {
  const Entrega({super.key});

  @override
  State<Entrega> createState() => _EntregaState();
}

Future<List<DeliveryModel>> fetchItems() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString('token');
  final int? residenceId = sharedPreferences.getInt('residenceId');
  final dio = Dio();

  final response = await dio.get(
    'http://192.168.1.74:5000/gateway/api/deliveries/residence/$residenceId',
    options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
      headers: {
        'x-access-token': token
      }, // Adicione o cabeçalho x-access-token aqui
    ),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data;
    return data.map((item) => DeliveryModel.fromJson(item)).toList();
  } else if (response.statusCode == 401) {
    throw Exception('Login Expirado');
  } else {
    throw Exception('Falha ao carregar dados da API');
  }
}

class _EntregaState extends State<Entrega> {
  late Future<List<DeliveryModel>> futureDeliveries;

  @override
  void initState() {
    super.initState();
    futureDeliveries = fetchItems();
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              'Entregas',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                decorationColor: Colors.yellow,
                decorationThickness: 5,
                color: Colors.transparent,
                shadows: [Shadow(offset: Offset(0, -10), color: Colors.black)],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DeliveryModel>>(
              future: futureDeliveries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                  return Container();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma entrega encontrada.'));
                } else {
                  final deliveries = snapshot.data;

                  return RefreshIndicator(
                    onRefresh: () async {
                      // Adicione a lógica de atualização aqui
                      await Future.delayed(
                        const Duration(seconds: 2),
                      ); // Simulação de uma tarefa assíncrona de atualização
                      setState(() {
                        // Atualize os dados ou recarregue a lista aqui
                        futureDeliveries = fetchItems();
                      });
                    },
                    child: ListView.builder(
                      itemCount: deliveries!.length,
                      itemBuilder: (context, index) {
                        final delivery = deliveries[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: kElevationToShadow[2],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment
                                  //       .center, // Define a centralização dos elementos na linha
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(
                                  //           10), // Aplicar preenchimento a todos os lados
                                  //       child: Text(
                                  //         delivery.status,
                                  //         style: const TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 15,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Porteiro: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${delivery.admin_name} ${delivery.admin_last_name}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Recebida: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formatDateTime(
                                                delivery.received_at,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Entregue: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formatDateTime(
                                                  delivery.delivered_at),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Status: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              delivery.status,
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
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

String formatDateTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return '-';
  }
  // Converter a string em um objeto DateTime
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Formatar a data e hora no formato desejado
  String formattedDate = DateFormat("dd/MM/yyyy 'às' HH:mm").format(dateTime);

  return formattedDate;
}
