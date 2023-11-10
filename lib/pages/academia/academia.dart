import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Academia extends StatefulWidget {
  const Academia({super.key});

  @override
  State<Academia> createState() => _AcademiaState();
}

class _AcademiaState extends State<Academia> {
  late Future<String?> _checkin;

  @override
  void initState() {
    super.initState();
    _checkin = getCheckin();
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
                            padding: EdgeInsets.all(30),
                            child: Text(
                              'Academia',
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
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Helen Cristina',
                                    style: TextStyle(
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
                                      'assets/avatar_m.png',
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: checked == true
                                        ? Colors.red
                                        : Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (checked) {
                                      await removeCheckin();
                                    } else {
                                      await addCheckin();
                                    }
                                  },
                                  child: Text(
                                    checked ? 'CHECK-OUT' : 'CHECK-IN',
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
    final dio = Dio();
    const url = 'http://192.168.61.235:5000/gateway/api/checks/resident/';

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
    const url = 'http://192.168.61.235:5000/gateway/api/checks';

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

    print(response.statusCode);

    setState(() {
      // Atualize os dados ou recarregue a lista aqui
      _checkin = getCheckin();
    });
  }

  Future<void> addCheckin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int? residentId = sharedPreferences.getInt('residentId');
    const url = 'http://192.168.61.235:5000/gateway/api/checks';

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

    print(response.statusCode);

    setState(() {
      // Atualize os dados ou recarregue a lista aqui
      _checkin = getCheckin();
    });
  }
}
