import 'dart:convert';

import 'package:condo_genius_beta/models/comment_model.dart';
import 'package:condo_genius_beta/models/post_model.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Comment>> fetchComments(id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString('token');
  final dio = Dio();

  final response = await dio.get(
    'http://192.168.182.235:5000/gateway/hub_digital/api/comment/$id',
    options: Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
      headers: {'x-access-token': token},
    ),
  );

  print(response.data);

  if (response.statusCode == 200) {
    if (response.data != null) {
      final List<dynamic> data = response.data;
      return data.map((item) => Comment.fromJson(item)).toList();
    } else {
      return [];
    }
  } else if (response.statusCode == 401) {
    throw Exception('Login Expirado');
  } else {
    throw Exception('Falha ao carregar dados da API');
  }
}

class CommentPage extends StatefulWidget {
  const CommentPage(this.post, {Key? key}) : super(key: key);
  final Post post;

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  late Future<List<Comment>> commentsArray;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentsArray = fetchComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    // Use a lista de comentários para exibir os comentários nesta página
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: kElevationToShadow[2],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _commentController,
                              minLines: 2,
                              maxLines: 2,
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
                                hintText: 'Escreva um aviso..',
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            iconSize: 25.0,
                            icon: const Icon(Icons.edit_note),
                            onPressed: () {
                              saveComment();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0), child: Text("Comentários")),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Comment>>(
                future: commentsArray,
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
                    final comments = snapshot.data;

                    return RefreshIndicator(
                      onRefresh: () async {
                        // Adicione a lógica de atualização aqui
                        await Future.delayed(
                          const Duration(seconds: 2),
                        ); // Simulação de uma tarefa assíncrona de atualização
                        setState(() {
                          // Atualize os dados ou recarregue a lista aqui
                          commentsArray = fetchComments(widget.post.id);
                        });
                      },
                      child: ListView.builder(
                        itemCount: comments!.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
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
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage(
                                                  'assets/avatar.png'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                '${comment.user.name} ${comment.user.lastName}',
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
                                                  comment.createdAt.toString()),
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
                                                    255, 99, 99, 99),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              comment.content.toString(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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
          )
        ],
      ),
    );
  }

  Future<void> saveComment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');
    final int userId = sharedPreferences.getInt('userId')!;

    final response = await http.post(
      Uri.parse('http://192.168.182.235:5000/gateway/hub_digital/api/comment'),
      headers: {
        'Content-type': 'application/json',
        'x-access-token': token.toString(),
      },
      body: jsonEncode({
        "user_id": userId,
        "post_id": widget.post.id,
        "content": _commentController.text,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      // Comment saved successfully, update the comment list
      setState(() {
        commentsArray = fetchComments(widget.post.id);
      });
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd/MM HH:mm').format(dateTime);
    return formattedDate;
  }
}
