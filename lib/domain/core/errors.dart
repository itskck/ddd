import 'package:firebase_flutter_ddd/domain/core/failures.dart';

class NotAutehnticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const explanation = 'Encountered a ValueFailure at an unrecoverable point.';
    return Error.safeToString('$explanation. Failure was $valueFailure');
  }
}
