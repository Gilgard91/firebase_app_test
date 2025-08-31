import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(AuthInitial()) {

    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onStatusChanged);

    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(AuthStatusChanged(
        isAuthenticated: user != null,
        userId: user?.uid,
        name: user?.displayName ?? ''
      ));
    });
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      // if (userCredential.user != null) {
      //   emit(AuthAuthenticated(
      //     userId: userCredential.user!.uid,
      //     email: userCredential.user!.email!,
      //   ));
      // }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      emit(AuthError(message: errorMessage));
    } catch (e) {
      emit(AuthError(message: 'Si è verificato un errore: $e'));
    }
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'Registrazione in corso...'));
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      await userCredential.user?.updateDisplayName(event.name?.trim());

      await userCredential.user?.reload();

      await _firebaseAuth.signOut();
      emit(const AuthRegistrationSuccess(
        message: 'Registrazione avvenuta con successo! Effettua il login.',
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getRegistrationErrorMessage(e.code);
      emit(AuthError(message: errorMessage));
    } catch (e) {
      emit(AuthError(message: 'Si è verificato un errore: $e'));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _firebaseAuth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Errore durante il logout: $e'));
    }
  }

  void _onStatusChanged(
      AuthStatusChanged event,
      Emitter<AuthState> emit,
      ) {
    if (event.isAuthenticated && event.userId != null) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(
          userId: event.userId!,
          email: user.email!,
          // name: user.displayName.toString()
          name: event.name
        ));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Nessun utente trovato per questa email.';
      case 'wrong-password':
        return 'Password errata.';
      case 'invalid-email':
        return 'L\'indirizzo email non è valido.';
      default:
        return 'Errore durante il login.';
    }
  }

  String _getRegistrationErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'La password fornita è troppo debole.';
      case 'email-already-in-use':
        return 'L\'account esiste già per questa email.';
      case 'invalid-email':
        return 'L\'indirizzo email non è valido.';
      default:
        return 'Errore durante la registrazione.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}