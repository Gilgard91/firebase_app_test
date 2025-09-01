import 'dart:async';

import 'package:app_test/pageflip/demo_page.dart';
import 'package:app_test/pageflip/page_flip.dart';
import 'package:app_test/register_page.dart';
import 'package:app_test/tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'home_page.dart';
import 'login_page.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {

    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
            path: '/login',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  ),
            ),
            routes: [
              GoRoute(
                path: 'register',
                name: 'register',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: RegisterPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                        position: animation.drive(
                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOut)),
                        ),
                        child: child,
                      ),
                ),
              )
            ]
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const TabBarPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
          ),
          routes: [
            GoRoute(
              name: 'screen',
              path: 'screen',
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: Screen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(
                      scale: animation.drive(
                        Tween(begin: 0.8, end: 1.0)
                            .chain(CurveTween(curve: Curves.decelerate)),
                      ),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
              ),
            ),
          ]
        ),

      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authBloc = context.read<AuthBloc>();
        final authState = authBloc.state;
        final bool loggedIn = authState is AuthAuthenticated;
        final bool loggingIn = state.matchedLocation == '/login';

        if (loggedIn && loggingIn) {
          return '/home';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream),
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

class BlocObserverLogger extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('onError -- ${bloc.runtimeType}, $error');
  }
}