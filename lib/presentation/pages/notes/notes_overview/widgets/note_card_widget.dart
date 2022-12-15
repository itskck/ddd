import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/application/notes/note_actor/bloc/note_actor_bloc.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/domain/notes/todo_item.dart';
import 'package:firebase_flutter_ddd/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context)
              .push(NoteFormPageRoute(editedNote: optionOf(note)));
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              note.body.getOrCrash(),
              style: const TextStyle(fontSize: 18),
            ),
            if (note.todos.length > 0) ...{
              const SizedBox(
                height: 4,
              ),
              Wrap(spacing: 8, children: [
                ...note.todos
                    .getOrCrash()
                    .map((todoIdem) => TodoDisplay(todo: todoIdem))
                    .iter
              ])
            }
          ]),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selected note: '),
            content: Text(
              note.body.getOrCrash(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL')),
              TextButton(
                  onPressed: () {
                    noteActorBloc.add(NoteActorEvent.deleted(note));
                    Navigator.pop(context);
                  },
                  child: const Text('DELETE')),
            ],
          );
        });
  }
}

class TodoDisplay extends StatelessWidget {
  const TodoDisplay({Key? key, required this.todo}) : super(key: key);

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).colorScheme.secondary,
          )
        else
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          ),
        Text(todo.name.getOrCrash()),
      ],
    );
  }
}
