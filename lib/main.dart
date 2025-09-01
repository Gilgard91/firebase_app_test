import 'dart:async';

import 'package:app_test/connection_checker/bloc/connection_bloc.dart';
import 'package:app_test/element/bloc/google_books_bloc.dart';
import 'package:app_test/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'core/theme/app_theme.dart';
import 'element/bloc/my_books_bloc.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = BlocObserverLogger();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<GoogleBooksBloc>(
          create: (context) => GoogleBooksBloc(),
        ),
        BlocProvider<BooksBloc>(
          create: (context) => BooksBloc(),
        ),
        BlocProvider<ConnectionBloc>(
          create: (context) => ConnectionBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'App di test',
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router(context),
          );
        },
      ),
    );
  }
}