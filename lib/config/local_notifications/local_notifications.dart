
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';


class LocalNotifications{

  static Future<void> requestPermissionLocalNotifications() async{ // Función que solicita los permisos de local notifications al SO (Autoriza si o no)

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // PLugin
    await flutterLocalNotificationsPlugin                                                                      // Esperamos que para android,
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()                         // los permisos se activen al abrir la app
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
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response){
    appRouter.push('/push-details/${ response.payload }');
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {

    const androidDetails = AndroidNotificationDetails( // Constructor de una instancia de AndroidNotificationDetails
      'channelId', 
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(  // Instancia de AndroidNotificationDetails
      android: androidDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // Instancia del plugin de LocalNotifications

    flutterLocalNotificationsPlugin.show( // Muestra la local notification con el payload y su configuración
      id, 
      title, 
      body, 
      notificationDetails, 
      payload: data 
    ); 
  }
}