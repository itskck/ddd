import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_flutter_ddd/domain/notes/note.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/note_form/note_form_page.dart';
import 'package:firebase_flutter_ddd/presentation/pages/notes/notes_overview/notes_overview_page.dart';
import 'package:firebase_flutter_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:firebase_flutter_ddd/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page',
  routes: [
    AutoRoute(page: SignInPage),
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: NotesOverviewPage),
    AutoRoute(page: NoteFormPage, fullscreenDialog: true)
  ],
)
class AppRouter extends _$AppRouter {}
