import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:firebase_flutter_ddd/domain/auth/user.dart';
import 'package:firebase_flutter_ddd/domain/core/errors.dart';
import 'package:firebase_flutter_ddd/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final Option<User> userOption =
        getIt<IAuthFacade>().getSignedInUser() as Option<User>;
    final user = userOption.getOrElse(() => throw NotAutehnticatedError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
