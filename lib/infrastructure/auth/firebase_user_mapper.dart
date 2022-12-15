import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:firebase_flutter_ddd/domain/auth/user.dart';
import 'package:firebase_flutter_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomainX on auth.User {
  User? toDomain() {
    final id = UniqueId.fromUniqueString(uid);
    return User(id: id);
  }
}
