import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Entrega extends StatefulWidget {
  const Entrega({super.key});

  @override
  State<Entrega> createState() => _EntregaState();
}

class _EntregaState extends State<Entrega> {
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
                        'Entregas',
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
                      padding: const EdgeInsets.only(
                        top: 5,
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
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text(
                                      'Entrega Recebida',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text("-"),
                                  ),
                                  Text(
                                    '24 de abri',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 99, 99, 99)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Horário: 17:25 PM'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('AP: 62'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Colaborador: João Porteiro'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text(
                                      'Entrega Recebida',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text("-"),
                                  ),
                                  Text(
                                    '24 de abri',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 99, 99, 99)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Horário: 17:25 PM'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('AP: 62'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Colaborador: João Porteiro'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text(
                                      'Entrega Recebida',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text("-"),
                                  ),
                                  Text(
                                    '24 de abri',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 99, 99, 99)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Horário: 17:25 PM'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('AP: 62'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Colaborador: João Porteiro'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text(
                                      'Entrega Recebida',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        10), //apply padding to all four sides
                                    child: Text("-"),
                                  ),
                                  Text(
                                    '24 de abri',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 99, 99, 99)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Horário: 17:25 PM'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('AP: 62'),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Colaborador: João Porteiro'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
