import 'package:condo_genius_beta/pages/academia/academia.dart';
import 'package:condo_genius_beta/pages/denuncias/denuncias.dart';
import 'package:condo_genius_beta/pages/entrega/entrega.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 120.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color.fromRGBO(12, 192, 223, 1), Colors.blue],
                ),
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('INÍCIO'), // for Right
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            shape: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 224, 224, 224),
              ),
            ), // for Left
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('ACADEMIA'), // for Right
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Academia()),
              );
            },
            shape: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 224, 224, 224),
              ),
            ), // for Left
          ),
          ListTile(
            leading: const Icon(Icons.markunread_mailbox),
            title: const Text('ENTREGAS'), // for Right
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Entrega()),
              );
            },
            shape: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 224, 224, 224),
              ),
            ), // for Left
          ),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred),
            title: const Text('DENÚNCIAS'), // for Right
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Denuncias()),
              );
            },
            shape: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 224, 224, 224),
              ),
            ), // for Left
          ),
        ],
      ),
    );
  }
}
