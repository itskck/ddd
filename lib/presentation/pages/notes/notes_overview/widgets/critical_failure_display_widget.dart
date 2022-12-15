import 'package:firebase_flutter_ddd/domain/notes/note_failure.dart';
import 'package:flutter/material.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure noteFailure;

  const CriticalFailureDisplay({Key? key, required this.noteFailure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '😱',
          style: TextStyle(fontSize: 100),
        ),
        Text(
          noteFailure.maybeMap(
              insufficientPermission: (_) => 'Insufficient permissions',
              orElse: () => 'Unexpected error \nPlease contact support'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
        TextButton(
          onPressed: () {
            print('Sending email');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.mail),
              SizedBox(
                width: 4,
              ),
              Text('I need help')
            ],
          ),
        )
      ],
    );
  }
}
