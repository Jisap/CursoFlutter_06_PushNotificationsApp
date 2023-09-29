
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificatons{

  static requestPermissionLocalNotifications() async{ // Función que solicita los permisos de local notifications al SO
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async{ // Función que inicializa las local notifications                        
  
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();        // Plugin

    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');  // settings/configuración android + icon

    const initializationSettings = InitializationSettings(                            // Inicialización local notific. con la config android
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize( // Inicializamos el plugin con la inicialización de las local notifications
      initializationSettings,
    );
  }
}