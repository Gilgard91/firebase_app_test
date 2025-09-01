part of 'google_books_bloc.dart';


abstract class GoogleBooksState extends Equatable {
  const GoogleBooksState();

  @override
  List<Object?> get props => [];
}

class GoogleBooksLoading extends GoogleBooksState {}

class GoogleBooksError extends GoogleBooksState {
  final String message;

  const GoogleBooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GoogleBooksLoaded extends GoogleBooksState {
  final List<Book> thrillerBooks;
  final List<Book> adventureBooks;

  final bool? isDeleting;

  const GoogleBooksLoaded(
      {
        required this.thrillerBooks,
        required this.adventureBooks,
        this.isDeleting
      }
      );

  @override
  List<Object?> get props => [thrillerBooks, adventureBooks];
}

final class GoogleBookInitial extends GoogleBooksState {}
