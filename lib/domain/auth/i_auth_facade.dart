import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_ddd/domain/auth/auth_failure.dart';
import 'package:firebase_flutter_ddd/domain/auth/email_address.dart';

abstract class IAuthFacade {
  Future<Option<User>?> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password});

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password});

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}
