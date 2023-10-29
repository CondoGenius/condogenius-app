import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioErrorHandler {
  final BuildContext context;

  DioErrorHandler(this.context);

  Future<Response<T>> handleDioError<T>(
      Future<Response<T>> Function() dioRequest) async {
    try {
      final response = await dioRequest();

      if (response.statusCode == 401) {
        // Tratamento do erro 401: Redirecionar para a página de login
        redirectToLogin();
      }

      return response;
    } catch (error) {
      // Tratar outros erros, se necessário
      return Response(
          requestOptions: RequestOptions(path: ''), statusCode: 500);
    }
  }

  void redirectToLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor:
            Color.fromARGB(255, 82, 82, 82), // Definindo o fundo como branco
        content: Center(
          child: Text(
            'Login Inválido !',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255,
                  255), // Definindo a cor do texto como preto (opcional)
            ),
          ),
        ),
      ),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.remove('residentId');
    await prefs.remove('residenceId');
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
