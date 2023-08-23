import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/perfil/perfil.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color.fromARGB(255, 182, 182, 182),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              },
              child: const CircleAvatar(
                radius: 21,
                backgroundImage: ExactAssetImage('assets/avatar_h.png'),
              ),
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
          height: MediaQuery.of(context).size.height - 100,
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
                        'Avisos',
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
                          const Flexible(
                            child: TextField(
                              minLines: 2,
                              maxLines: 2,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
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
                                hintText: 'Escreva um aviso..',
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            iconSize: 25.0,
                            icon: const Icon(Icons.edit_note),
                            onPressed: () {},
                          ),
                        ],
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
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 141, 141, 141),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 182, 182),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/avatar_m.png'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      10), //apply padding to all four sides
                                  child: Text(
                                    'Julia Screffer',
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
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 99, 99, 99)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          8.0) //                 <--- border radius here
                                      ),
                                ),
                                child: const Text(
                                    'Atenção: no dia 30/04/23 o registro geral será fechado, por conta de reformas no AP 62.'),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                  ),
                                  icon: const Icon(
                                    Icons.thumb_up_off_alt,
                                    size: 24.0,
                                  ),
                                  label: const Text('57'),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 24.0,
                                  ),
                                  label: const Text('6'),
                                ),
                              ],
                            ),
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
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 141, 141, 141),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 182, 182),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/avatar_m.png'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      10), //apply padding to all four sides
                                  child: Text(
                                    'Hellen Cristina',
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
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 99, 99, 99)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          8.0) //                 <--- border radius here
                                      ),
                                ),
                                child: const Text(
                                    'Nova Fechadura do portão principal'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 25,
                                right: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  const Text('Digital'),
                                  LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    animation: true,
                                    lineHeight: 30.0,
                                    animationDuration: 2500,
                                    percent: 0.8,
                                    center: const Text("15"),
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.blue,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text('Manual'),
                                  LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    animation: true,
                                    lineHeight: 30.0,
                                    animationDuration: 2500,
                                    percent: 0.2,
                                    center: const Text("5"),
                                    barRadius: const Radius.circular(20),
                                    progressColor: Colors.green,
                                  )
                                ],
                              ),
                            )
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
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 141, 141, 141),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 182, 182),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/avatar_h.png'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      10), //apply padding to all four sides
                                  child: Text(
                                    'Igor Mucharski',
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
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 99, 99, 99)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          8.0) //                 <--- border radius here
                                      ),
                                ),
                                child: const Text(
                                    'Perdi minha chave do carro, se alguém viu por favor falar!'),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  icon: const Icon(
                                    Icons.thumb_up_off_alt,
                                    size: 24.0,
                                  ),
                                  label: const Text('15'),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 24.0,
                                  ),
                                  label: const Text('6'),
                                ),
                              ],
                            ),
                          ],
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
