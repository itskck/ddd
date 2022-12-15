import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/domain/notes/note_failure.dart';
import 'package:firebase_flutter_ddd/domain/notes/value_objects.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@Injectable()
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<Initialized>(_initialized);
    on<Saved>(_saved);
    on<BodyChanged>(_bodyChanged);
    on<ColorChanged>(_colorChanged);
    on<TodosChanged>(_todosChanged);
  }

  Future<void> _initialized(
    Initialized event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(
      event.initialNoteOption.fold(
        () => state,
        (initialNote) => state.copyWith(note: initialNote, isEditing: true),
      ),
    );
  }

  Future<void> _bodyChanged(
    BodyChanged event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(
      state.copyWith(
        note: state.note.copyWith(body: NoteBody(event.bodyStr)),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> _colorChanged(
    ColorChanged event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(
      state.copyWith(
        note: state.note.copyWith(color: NoteColor(event.color)),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> _todosChanged(
      TodosChanged event, Emitter<NoteFormState> emit) async {
    emit(
      state.copyWith(
        note: state.note.copyWith(
          todos: List3(event.todos.map((primitive) => primitive.toDomain())),
        ),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> _saved(Saved event, Emitter<NoteFormState> emit) async {
    Either<NoteFailure, Unit>? failureOrSuccess;

    emit(state.copyWith(isSaving: true, saveFailureOrSuccessOption: none()));
    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing
          ? await _noteRepository.update(state.note)
          : await _noteRepository.create(state.note);
    }
    emit(
      state.copyWith(
        isSaving: false,
        showErrorMessage: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
