// ignore_for_file: unused_field

import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/domain/auth/auth_failure.dart';
import 'package:firebase_flutter_ddd/domain/auth/email_address.dart';
import 'package:firebase_flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@Injectable()
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<SignInWithEmailAndPasswordPressed>(_signInWithEmailAndPasswordPressed);
    on<RegisterWithEmailAndPasswordPressed>(
      _registerWithEmailAndPasswordPressed,
    );
    on<RegisterWithGooglePressed>(_signInWithGooglePressed);
  }

  void _emailChanged(EmailChanged event, Emitter<SignInFormState> emit) => emit(
        state.copyWith(
          emailAddress: EmailAddress(event.emailStr),
          authFailureOrSuccess: none(),
        ),
      );

  void _passwordChanged(PasswordChanged event, Emitter<SignInFormState> emit) =>
      emit(
        state.copyWith(
          password: Password(event.passwordStr),
          authFailureOrSuccess: none(),
        ),
      );

  Future _signInWithEmailAndPasswordPressed(
    SignInWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(isSubmitting: true, authFailureOrSuccess: none()));

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessage: true,
        authFailureOrSuccess: optionOf(failureOrSuccess),
      ),
    );
  }

  Future _signInWithGooglePressed(
    RegisterWithGooglePressed event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, authFailureOrSuccess: none()));
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccess: some(failureOrSuccess),
      ),
    );
  }

  Future _registerWithEmailAndPasswordPressed(
    RegisterWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(isSubmitting: true, authFailureOrSuccess: none()));

      failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccess: optionOf(failureOrSuccess),
        ),
      );
    }
    emit(state.copyWith(showErrorMessage: true, authFailureOrSuccess: none()));
  }
}
