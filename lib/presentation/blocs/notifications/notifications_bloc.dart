import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async { // Stream de datos cuando la app esta en 2º plano

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}



class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> { // Como un provider de estado y sus métodos
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;       // Permite escuchar y emitir notifications (instancia de firebase messagin)
  
  // Constructor
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>( _notificationsStatusChanged ); // Escuchamos la emisión del evento relativo al cambio de status en las notif.push
    _initialStatusCheck();                                        // Obtenemos el status actual y el token para poder mandar y recibir mensajes
    _onForegroundMessage();                                       // Abrimos el stream de mensajes desde firebase
  }

  static Future<void> initializeFCM() async{                      // Inicialización de Firebase Cloud Messagin
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit ){ // Si cambio el estado de status
    emit(                                                                                                // emitimos 
      state.copyWith(                                                                                    // un nuevo estado (copia) 
        status: event.status                                                                             // con el estado del evento (nuevo status)
      )
    );
    _getFCMToken(); // y obtenemos el token de autorización si estamos authorized
  }

  void _initialStatusCheck() async{
    final settings = await messaging.getNotificationSettings();   // De la instancia de firebase messagin obtengo su estado
    add( NotificationStatusChanged(settings.authorizationStatus));// Emitimos un nuevo estado con el estado de la authorizationStatus
  }

  void _getFCMToken() async {
    
    if( state.status != AuthorizationStatus.authorized ) return; // Sino esta autorizado no muestro el token
    final token = await messaging.getToken();                    // Si si lo esta obtengo el token y lo muestro.
    print(token);
  }

  void _handleRemoteMessage( RemoteMessage message ){ // RemoteMessage es el mensaje enviado desde firebase
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;  
      
    print('Message also contained a notification: ${message.notification}'); 
  }

  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(( _handleRemoteMessage )); // Stream de datos cuando la aplicación esta activa
  }


  void requestPermission() async { // Llamaremos a esta configuración cuando toquemos en la appbar el engrane
    NotificationSettings settings = await messaging.requestPermission( 
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(NotificationStatusChanged( settings.authorizationStatus)); // Añadimos el evento de escucha del cambio de status
  }
}
