import 'package:firebase_flutter_ddd/application/notes/note_watcher/bloc/note_watcher_bloc.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/notes_overview/widgets/error_note_widget.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/notes_overview/widgets/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
        builder: (context, state) {
      return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
          loadSuccess: (state) => ListView.builder(
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  if (note.failureOption.isSome()) {
                    return ErrorNoteCard(note: note);
                  } else {
                    return NoteCard(note: note);
                  }
                },
                itemCount: state.notes.size,
              ),
          loadFailure: (state) =>
              CriticalFailureDisplay(noteFailure: state.noteFailure));
    });
  }
}
