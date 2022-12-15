import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_flutter_ddd/application/auth/bloc/auth_bloc.dart';
import 'package:firebase_flutter_ddd/application/auth/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:firebase_flutter_ddd/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccess.fold(
          () => {},
          (either) => either.fold(
              (failure) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                      failure.map(
                        cancledByUser: (_) =>
                            const SnackBar(content: Text('Cancelled')),
                        serverError: (_) =>
                            const SnackBar(content: Text('Server Error')),
                        emailAlreadyInUse: (_) =>
                            const SnackBar(content: Text('Email in Use')),
                        invalidEmailAndPasswordCombination: (_) =>
                            const SnackBar(
                                content: Text('Invalid Email And Password')),
                      ),
                    )
                  }, (_) {
            AutoRouter.of(context).push(const NotesOverviewPageRoute());
            context.read<AuthBloc>().add(const AuthCheckRequested());
          }),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 130,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.emailChanged(value)),
                validator: (_) => context
                    .read<SignInFormBloc>()
                    .state
                    .emailAddress
                    .value
                    .fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Invalid Email',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) =>
                    context.read<SignInFormBloc>().state.password.value.fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) => 'Short Password',
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .signInWithEmailAndPasswordPressed(),
                            );
                      },
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed(),
                            );
                      },
                      child: const Text('REGISTER'),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(
                        const SignInFormEvent.registerWithGooglePressed(),
                      );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("SIGN IN WITH GOOGLE"),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(height: 0),
                const LinearProgressIndicator()
              ]
            ],
          ),
        );
      },
    );
  }
}
