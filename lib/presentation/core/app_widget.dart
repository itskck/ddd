import 'package:auto_route/auto_route.dart';
import 'package:firebase_flutter_ddd/application/auth/bloc/auth_bloc.dart';
import 'package:firebase_flutter_ddd/injection.dart';
import 'package:firebase_flutter_ddd/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final appRouter = AppRouter();

class AppWidget extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        )
      ],
      child: MaterialApp.router(
        title: 'Notes',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
        routerDelegate: AutoRouterDelegate(appRouter),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
      // home: const SignInPage(),
    );
  }
}
