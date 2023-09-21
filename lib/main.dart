import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

import 'config/theme/app_theme.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized(); // Es necesario para poder usar las API de Flutter que dependen de la plataforma(Ios/adroid), como las notificaciones push.
  await NotificationsBloc.initializeFCM();   // Inicializa el sistema de cloud messaging de firebase 

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc())
      ],
      child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
