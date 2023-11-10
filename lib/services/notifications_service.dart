import 'package:condo_genius_beta/main.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> iniNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? residentId = sharedPreferences.getInt('residentId');
    final String? token = sharedPreferences.getString('token');
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    const url = 'http://192.168.61.235:5000/gateway/residents/api/residents/';

    if (residentId != null) {
      final response = await Dio().put(
        '$url$residentId',
        data: {'device_token': fcmToken},
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
        print('Token salvo com sucesso');
      } else {
        print('Erro ao salvar o token');
      }
    }

    initPushNotification();
  }

  Future<void> handlerMessage(RemoteMessage? message) async {
    if (message == null) return;

    navigatorKey.currentState!.pushNamed('/Home', arguments: message);
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
  }
}
