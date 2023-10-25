import 'package:condo_genius_beta/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> iniNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    initPushNotification();
  }

  Future<void> handlerMessage(RemoteMessage? message) async {
    if (message == null) return;

    navigatorKey.currentState!
        .pushNamed('/Home', arguments: message);
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
  }
}

