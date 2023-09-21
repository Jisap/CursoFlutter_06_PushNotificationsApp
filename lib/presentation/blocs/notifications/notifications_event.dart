part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();

}
 
class NotificationStatusChanged extends NotificationsEvent { // Clase que emite un evento cuando recibe un status (cambia el estado)
  
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
}
