import 'package:condo_genius_beta/models/comment_model.dart';
import 'package:condo_genius_beta/models/post_model.dart';
import 'package:condo_genius_beta/pages/components/menu.dart';
import 'package:condo_genius_beta/pages/home.dart';
import 'package:condo_genius_beta/pages/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Comment>> fetchComments(id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString('token');
  final dio = Dio();

  final response = await dio.get(
    'http://192.168.1.74:5000/gateway/hub_digital/api/comment/$id',
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
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late Future<List<Comment>> comments;

  @override
  void initState() {
    super.initState();
    // comments = fetchComments(widget.post.id);
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
              child: widget.post.comments.isEmpty
                  ? const Center(
                      // Exibe a mensagem quando não há comentários
                      child: Text("Nenhum comentário disponível"),
                    )
                  : ListView.builder(
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = widget.post.comments[index];
                        return Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
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
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "${comment.user.name} ${comment.user.lastName}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("-"),
                                    ),
                                    Text(
                                      formatDateTime(comment.createdAt.toString()),
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 99, 99, 99),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 99, 99, 99),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      comment.content.toString(),
                                    ),
                                  ),
                                ),
                                // ListTile(
                                //   title: Text(comment.content),
                                //   subtitle: Text(
                                //       formatDateTime(comment.createdAt.toString())),
                                // ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd/MM HH:mm').format(dateTime);
    return formattedDate;
  }
}
