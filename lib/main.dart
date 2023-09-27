import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Es necesario para poder usar las API de Flutter que dependen de la plataforma(Ios/adroid), como las notificaciones push.
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler); // Permite recibir notifications en segundo plano
  await NotificationsBloc
      .initializeFCM(); // Inicializa el sistema de cloud messaging de firebase

  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (_) => NotificationsBloc())],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandleNotificationInteractions(
          child:
              child!), // Construida e inicializada la app llamamos al constructor de un widget
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  // Este widget recibe como child el widget del MainApp. Estamos envolviendo toda la app en este widget

  final Widget child;

  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage(); // Obtenemos el primer mensaje desde Firebase

    if (initialMessage != null) {
      // Si hay primer mensaje
      _handleMessage(initialMessage); // recurrimos a este método.
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // Recibimos el mensaje desde firebase

    context.read<NotificationsBloc>().handleRemoteMessage(
        message); // Mapeamos la respuesta como una notification que contiene el messageId

    final messageId = message.messageId?.replaceAll(":", '').replaceAll(
        '%', ''); // Limpiamos el messageId de símbolos raros, si es que quedan.

    appRouter.push(
        '/push-details/$messageId'); // Hacemos push hacia la ruta 'push-details' con el messageId
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
