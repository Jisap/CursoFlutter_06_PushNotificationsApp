
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> requestPermissionLocalNotifications() async{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

}