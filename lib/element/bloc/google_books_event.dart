part of 'google_books_bloc.dart';

abstract class GoogleBooksEvent extends Equatable {
  const GoogleBooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoogleBooks extends GoogleBooksEvent {
  final String? userId;

  const LoadGoogleBooks({this.userId});

  @override
  List<Object?> get props => [userId];
}