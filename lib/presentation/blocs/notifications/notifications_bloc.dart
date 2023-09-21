import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> { // Como un provider de estado y sus métodos
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;       // Permite escuchar y emitir notifications
  
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>( _notificationsStatusChanged ); // Escuchamos la emisión del evento relativo al cambio de status en las notif.push
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
