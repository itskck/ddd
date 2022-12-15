import 'package:auto_route/auto_route.dart';
import 'package:firebase_flutter_ddd/application/auth/bloc/auth_bloc.dart';
import 'package:firebase_flutter_ddd/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
            initial: (_) {},
            authenticated: (_) =>
                AutoRouter.of(context).push(const NotesOverviewPageRoute()),
            /*AutoRouter.of(context).pushNamed(path),*/
            unauthenticated: (_) =>
                AutoRouter.of(context).push(const SignInPageRoute()));
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
