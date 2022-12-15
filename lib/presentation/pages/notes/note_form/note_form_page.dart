import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/injection.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/widgets/add_todo_tile_wodget.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/widgets/body_field_widget.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/widgets/color_field_widget.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/widgets/todo_list_widget.dart';
import 'package:firebase_flutter_ddd/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatelessWidget {
  final Option<Note> editedNote;

  const NoteFormPage({Key? key, required this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<NoteFormBloc>()..add(NoteFormEvent.initialized(editedNote)),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) {
              either.fold(
                  (failure) => FlushbarHelper.createError(
                        message: failure.map(
                            unexpected: (_) =>
                                'Unexpected error occured, please contact support',
                            insufficientPermission: (_) =>
                                'Insufficient permissions',
                            unableToUpdate: (_) => 'Could not update the note'),
                      ).show(context), (_) {
                AutoRouter.of(context).popUntil(
                  (route) => route.settings.name == NoteFormPageRoute.name,
                );
              });
            },
          );
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(
                isSaving: state.isSaving,
              )
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SavingInProgressOverlay({Key? key, required this.isSaving})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.0) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(),
              Text(
                'Saving',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessage != c.showErrorMessage,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const BodyField(),
                  const ColorField(),
                  const TodoList(),
                  const AddTodoTile(),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
