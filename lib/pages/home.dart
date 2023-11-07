import 'dart:convert';
import 'package:condo_genius_beta/models/post_model.dart';
import 'package:condo_genius_beta/pages/commets.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:condo_genius_beta/services/notifications_service.dart';
import 'package:condo_genius_beta/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<void> _initializeFirebaseAndNotifications() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().iniNotifications();

  // O código assíncrono foi movido para este método
}

class _HomePageState extends State<HomePage> {
  late AuthService authService;
  late Future<List<Post>> futurePosts;
  var userId = 0;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    checkLoginStatus();
    _initializeFirebaseAndNotifications();
    futurePosts = getHub();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await authService.isUserLoggedIn();
    if (!isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<List<Post>> getHub() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    userId = sharedPreferences.getInt('userId')!;
    final dio = Dio();

    final response = await dio.get(
      'http://192.168.1.74:5000/gateway/hub_digital/api/post',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        headers: {
          'x-access-token': token,
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => Post.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Login Expirado');
    } else {
      throw Exception('Falha ao carregar dados da API');
    }
  }

  hasVoted() {
    return true;
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
          // CircleAvatar(
          //   radius: 21,
          //   backgroundColor: const Color.fromARGB(255, 182, 182, 182),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const Perfil()),
          //       );
          //     },
          //     child: const CircleAvatar(
          //       radius: 21,
          //       backgroundImage: ExactAssetImage('assets/avatar_h.png'),
          //     ),
          //   ),
          // ),
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
              'HUB Digital',
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
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Login expirado!'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum dado encontrado!'));
                } else {
                  final posts = snapshot.data;

                  return RefreshIndicator(
                    onRefresh: () async {
                      // Adicione a lógica de atualização aqui
                      await Future.delayed(
                        const Duration(seconds: 2),
                      ); // Simulação de uma tarefa assíncrona de atualização
                      setState(() {
                        // Atualize os dados ou recarregue a lista aqui
                        futurePosts = getHub();
                      });
                    },
                    child: ListView.builder(
                      itemCount: posts!.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        if (post.poll == null) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    10), // Aplicar preenchimento a todos os lados
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 141, 141, 141),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 21,
                                            backgroundColor: Color.fromARGB(
                                                255, 182, 182, 182),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                  'assets/avatar_m.png'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                10), //apply padding to all four sides
                                            child: Text(
                                              "${post.user.name} ${post.user.lastName}",
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
                                            formatDateTime(
                                                post.createdAt.toString()),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 99, 99, 99)),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 99, 99, 99)),
                                            borderRadius: const BorderRadius
                                                    .all(
                                                Radius.circular(
                                                    8.0) //                 <--- border radius here
                                                ),
                                          ),
                                          child: Text(post.content.toString()),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              if (post.comments.isNotEmpty) {
                                                // Navegar para a página de comentários apenas se houver comentários
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommentPage(post),
                                                  ),
                                                );
                                              } else {
                                                // Mostrar uma mensagem de aviso se não houver comentários
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Não há comentários disponíveis.'),
                                                  ),
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black,
                                            ),
                                            icon: const Icon(
                                              Icons.chat_bubble_outline,
                                              size: 24.0,
                                            ),
                                            label: Text(post.comments.length
                                                .toString()),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          late bool hasVoted = false;
                          late int userVotedOptionId = 0;

                          for (var element in post.poll!.options) {
                            if (element.votes.contains(userId)) {
                              hasVoted = true;
                              userVotedOptionId = element.id;
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 141, 141, 141),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 21,
                                            backgroundColor: Color.fromARGB(
                                                255, 182, 182, 182),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                  'assets/avatar_m.png'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                10), //apply padding to all four sides
                                            child: Text(
                                              "${post.user.name} ${post.user.lastName}",
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
                                            formatDateTime(
                                                post.createdAt.toString()),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 99, 99, 99)),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 99, 99, 99)),
                                            borderRadius: const BorderRadius
                                                    .all(
                                                Radius.circular(
                                                    8.0) //                 <--- border radius here
                                                ),
                                          ),
                                          child: Text(
                                              post.title.toString()),
                                        ),
                                      ),
                                      FlutterPolls(
                                        pollId: post.poll!.id.toString(),
                                        votesText: 'Votos',
                                        hasVoted: hasVoted,
                                        userVotedOptionId:
                                            userVotedOptionId.toString(),
                                        createdBy: post.user.name.toString(),
                                        onVoted: (PollOption pollOption,
                                            int newTotalVotes) async {
                                          await Future.delayed(
                                              const Duration(seconds: 1));

                                          /// If HTTP status is success, return true else false
                                          return saveVoto(
                                              pollOption.id.toString(),
                                              post.poll!.id.toString());
                                        },
                                        pollTitle: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            post.title.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        pollOptions: List<PollOption>.from(
                                          post.poll!.options.map(
                                            (option) {
                                              var a = PollOption(
                                                id: option.id.toString(),
                                                title: Text(
                                                  option.title.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                votes: option.quantityOfVotes
                                                    .toInt(),
                                              );
                                              return a;
                                            },
                                          ),
                                        ),
                                        votedPercentageTextStyle:
                                            const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentPage(post),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black,
                                            ),
                                            icon: const Icon(
                                              Icons.chat_bubble_outline,
                                              size: 24.0,
                                            ),
                                            label: Text(post.comments.length
                                                .toString()),
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

  Future<bool> saveVoto(String optionId, String enquete) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    print({
      'survey_id': enquete,
      'poll_option_id': optionId,
      'user_id': userId,
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.74:5000/gateway/hub_digital/api/vote'),
      headers: {
        'Content-type': 'application/json',
        'x-access-token': token.toString()
      },
      body: jsonEncode({
        'survey_id': enquete,
        'poll_option_id': optionId,
        'user_id': userId,
      }),
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 500 || response.statusCode == 400) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(
              255, 82, 82, 82), // Definindo o fundo como branco
          content: Center(
            child: Text(
              body['message'],
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255,
                    255), // Definindo a cor do texto como preto (opcional)
              ),
            ),
          ),
        ),
      );

      return false;
    }

    return true;
  }

  String formatDateTime(String dateTimeString) {
    // Converter a string em um objeto DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Formatar a data e hora no formato desejado
    String formattedDate = DateFormat('dd/MM HH:mm').format(dateTime);

    return formattedDate;
  }
}
