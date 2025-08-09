import 'dart:async';

import 'package:app_test/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'element/bloc/musician_bloc.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Opzionale: abilita il Bloc Observer per debug
  Bloc.observer = SimpleBlocObserver();

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
        BlocProvider<MusiciansBloc>(
          create: (context) => MusiciansBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'App di test',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            routerConfig: _createRouter(context),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final bool loggedIn = authState is AuthAuthenticated;
        final bool loggingIn = state.matchedLocation == '/login';

        if (!loggedIn && !loggingIn) {
          return '/login';
        }

        if (loggedIn && loggingIn) {
          return '/home';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Bloc Observer per debug (opzionale)
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}