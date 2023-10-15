import 'package:condo_genius_beta/models/delivery_model.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Entrega extends StatefulWidget {
  const Entrega({super.key});

  @override
  State<Entrega> createState() => _EntregaState();
}

Future<List<DeliveryModel>> fetchItems() async {
  final response = await Dio().get('http://192.168.1.74:7003/api/deliveries');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data;
    return data.map((item) => DeliveryModel.fromJson(item)).toList();
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
                  return Center(child: Text('Erro: ${snapshot.error}'));
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
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            10), //apply padding to all four sides
                                        child: Text(
                                          delivery.status,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(
                                            10), //apply padding to all four sides
                                        child: Text("-"),
                                      ),
                                      Text(
                                        delivery.delivered_at,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 99, 99, 99)),
                                      )
                                    ],
                                  ),
                                  // const Column(
                                  //   children: [
                                  //     Align(
                                  //       alignment: Alignment.centerLeft,
                                  //       child: Text('Horário: 17:25 PM'),
                                  //     ),
                                  //     Align(
                                  //       alignment: Alignment.centerLeft,
                                  //       child: Text('AP: 62'),
                                  //     ),
                                  //     Align(
                                  //       alignment: Alignment.centerLeft,
                                  //       child: Text('Colaborador: João Porteiro'),
                                  //     ),
                                  //   ],
                                  // ),
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
