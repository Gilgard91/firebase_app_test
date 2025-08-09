// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart'; // Necessario per il BuildContext del redirect
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import 'auth/bloc/auth_bloc.dart';
// import 'auth/bloc/auth_state.dart';
// import 'element/bloc/musician_bloc.dart';
// import 'home_page.dart';
// import 'login_page.dart';
//
// class AppRouter {
//   static GoRouter router(AuthBloc authBloc) {
//     return GoRouter(
//       initialLocation: '/login',
//       routes: [
//         GoRoute(
//           path: '/login',
//           builder: (context, state) => const LoginPage(),
//         ),
//         GoRoute(
//           path: '/home',
//           builder: (context, state) => const HomePage(),
//         ),
//       ],
//       redirect: (BuildContext context, GoRouterState state) {
//         final authState = authBloc.state;
//         final bool loggedIn = authState is AuthAuthenticated;
//         final bool loggingIn = state.matchedLocation == '/login';
//
//         // Se l'utente non è loggato e non sta andando alla pagina di login,
//         // reindirizza a /login.
//         if (!loggedIn && !loggingIn) {
//           return '/login';
//         }
//
//         // Se l'utente è loggato e sta cercando di accedere a /login,
//         // reindirizza a /home.
//         if (loggedIn && loggingIn) {
//           return '/home';
//         }
//
//         // Nessun reindirizzamento
//         return null;
//       },
//       // refreshListenable per reagire ai cambiamenti dello stato di autenticazione
//       refreshListenable: GoRouterRefreshStream(authBloc.stream),
//     );
//   }
// }
//
// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen(
//           (dynamic _) => notifyListeners(),
//     );
//   }
//
//   late final StreamSubscription<dynamic> _subscription;
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
//
// // Alternativa più semplice: creare il router dentro MyApp
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => AuthBloc(),
//         ),
//         BlocProvider<MusiciansBloc>(
//           create: (context) => MusiciansBloc(),
//         ),
//       ],
//       child: Builder(
//         builder: (context) {
//           // Ottieni l'AuthBloc dal context
//           final authBloc = context.read<AuthBloc>();
//
//           return MaterialApp.router(
//             title: 'App di test',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               useMaterial3: true,
//             ),
//             routerConfig: AppRouter.router(authBloc),
//           );
//         },
//       ),
//     );
//   }
// }