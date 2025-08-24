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
  final List<Book> books;
  final bool? isDeleting;

  const BooksLoaded({required this.books, this.isDeleting});

  @override
  List<Object?> get props => [books];
}

class BooksError extends BooksState {
  final String message;

  const BooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookAdded extends BooksLoaded {
  final String message;

  const BookAdded({
    required this.message,
    required super.books,
  });

  @override
  List<Object?> get props => [message, books];
}