import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});
}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String name;


  const AuthAuthenticated({required this.userId, required this.email, required this.name});

  @override
  List<Object?> get props => [userId, email];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthRegistrationSuccess extends AuthState {
  final String message;

  const AuthRegistrationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}