import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Função para verificar se o usuário está logado
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    // Verifica se o token existe
    if (token != null) {
      // O usuário está logado
      return true;
    } else {
      // O usuário não está logado
      return false;
    }
  }
}
