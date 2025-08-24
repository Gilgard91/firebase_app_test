import 'package:equatable/equatable.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooks extends BooksEvent {
  final String? userId;

  const LoadBooks({this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteBookAndReload extends BooksEvent {
  final int bookId;

  const DeleteBookAndReload({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class AddBook extends BooksEvent {
  final String name;
  final int birthYear;
  final String userId;

  const AddBook({
    required this.name,
    required this.birthYear,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, birthYear, userId];
}

class DeleteBook extends BooksEvent {
  final int bookId;

  const DeleteBook({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class BooksSubscriptionRequested extends BooksEvent {
  final String userId;

  const BooksSubscriptionRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}