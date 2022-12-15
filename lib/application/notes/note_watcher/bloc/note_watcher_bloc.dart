// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'note_watcher_bloc.freezed.dart';
part 'note_watcher_event.dart';
part 'note_watcher_state.dart';

@Injectable()
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial()) {
    on<WatchAllStarted>(_loadNotes);
    on<WatchUncompletedStarted>(_loadUncompletedNotes);
    on<NotesRecived>(_notesRecieved);
  }

  Future _loadNotes(
      NoteWatcherEvent event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchAll().listen(
        (failureOrNotes) =>
            add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }

  Future _loadUncompletedNotes(
      NoteWatcherEvent event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
        (failureOrNotes) =>
            add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }

  Future _notesRecieved(
      NotesRecived event, Emitter<NoteWatcherState> emit) async {
    event.failureOrNotes.fold((f) => emit(NoteWatcherState.loadFailure(f)),
        (notes) => emit(NoteWatcherState.loadSuccess(notes)));
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
