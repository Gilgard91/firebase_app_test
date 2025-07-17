// In router.dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Necessario per il BuildContext del redirect
import 'package:go_router/go_router.dart';

import 'home_page.dart';
import 'login_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Potrebbe essere gestito dal redirect
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(), // Aggiunto const
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(), // Aggiunto const
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool loggingIn = state.matchedLocation == '/login';

      // Se l'utente non è loggato e non sta andando alla pagina di login,
      // reindirizza a /login.
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // Se l'utente è loggato e sta cercando di accedere a /login,
      // reindirizza a /home.
      if (loggedIn && loggingIn) {
        return '/home';
      }

      // Nessun reindirizzamento necessario.
      return null;
    },
    // Aggiungi un refreshListenable per reagire ai cambiamenti dello stato di autenticazione
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  );
}

// Classe helper per il refreshListenable
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
    