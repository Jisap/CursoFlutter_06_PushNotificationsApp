part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {

  final AuthorizationStatus status;
  final List<PushMessage> notifications; // domain/notifications/push_message.dart

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined, 
    this.notifications = const[],
  });

  NotificationsState 
    copyWith({
      AuthorizationStatus? status,
      List<PushMessage>? notifications,
    }) => NotificationsState(
      status:  status ?? this.status,
      notifications: notifications ?? this.notifications
    );
  
  @override
  List<Object> get props => [status, notifications];
}


