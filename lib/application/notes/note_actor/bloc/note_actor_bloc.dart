// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:firebase_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_bloc.freezed.dart';
part 'note_actor_event.dart';
part 'note_actor_state.dart';

@Injectable()
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<Deleted>(_deleteEvent);
  }

  Future _deleteEvent(
    NoteActorEvent event,
    Emitter<NoteActorState> emit,
  ) async {
    emit(const NoteActorState.actionInProgress());
    final possibleFailure = await _noteRepository.delete(event.note);
    possibleFailure.fold(
      (f) => emit(NoteActorState.deleteFailure(f)),
      (_) => emit(const NoteActorState.deleteSuccess()),
    );
  }
}
