import 'package:equatable/equatable.dart';

import 'book.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<Book> myBooks;

  final bool? isDeleting;

  const BooksLoaded(
      {
        required this.myBooks,
        this.isDeleting
      }
      );

  @override
  List<Object?> get props => [myBooks];
}

class BooksError extends BooksState {
  final String message;

  const BooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookAdded extends BooksState {
  final String message;
  final List<Book> books;

  const BookAdded({
    required this.books,
    required this.message
  });

  @override
  List<Object?> get props => [message, books];
}