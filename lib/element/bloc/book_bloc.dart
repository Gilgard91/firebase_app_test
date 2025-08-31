import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../api/BooksApiService.dart';
import 'book.dart';
import 'book_event.dart';
import 'book_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _BooksSubscription;

  BooksBloc({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(BooksInitial()) {

    on<LoadBooks>(_onLoadBooks);
    on<DeleteBook>(_onDeleteBook);
    on<AddBook>(_onAddBook);
    on<DeleteBookAndReload>(_onDeleteBookAndReload);
  }


  Future<void> _onLoadBooks(
      LoadBooks event,
      Emitter<BooksState> emit,
      ) async {
    emit(BooksLoading());

    List<Book> myBooks = [];


    try {
      myBooks = await BookApiService.getBooksBackend();
    } catch (e) {
      debugPrint('Errore caricamento myBooks: $e');
    }

    emit(BooksLoaded(
        myBooks: myBooks
    ));
  }

  Future<void> _onDeleteBookAndReload(
      DeleteBookAndReload event,
      Emitter<BooksState> emit,
      ) async {
    try {
      final currentState = state;
      if (currentState is BooksLoaded) {
        emit(BooksLoaded(
          myBooks: currentState.myBooks,
          isDeleting: true,
        ));
      }

      // Elimina il libro
      await BookApiService.deleteBook(event.bookId);

      emit(BooksLoading());

      final List<Book> myBooks = await BookApiService.getBooksBackend();

      emit(BooksLoaded(myBooks: myBooks));
    } catch (e) {
      emit(BooksError(message: 'Errore nell\'eliminazione: $e'));
    }
  }

  Future<void> _onAddBook(
      AddBook event,
      Emitter<BooksState> emit,
      ) async {
    try {
      emit(BooksLoading());

      final book = Book(
        title: event.title,
        author: event.author,
        description: event.description,
      );

      await BookApiService.addBook(book);

      List<Book> myBooks = [];

      myBooks = await BookApiService.getBooksBackend();

      emit(BooksLoaded(
          myBooks: myBooks
      ));

    } catch (e) {
      emit(BooksError(message: 'Errore nell\'aggiunta: $e'));
    }
  }

  Future<void> _onDeleteBook(
      DeleteBook event,
      Emitter<BooksState> emit,
      ) async {
    try {
      await BookApiService.deleteBook(event.bookId);

    } catch (e) {
      emit(BooksError(message: 'Errore nella cancellazione: $e'));
    }
  }

}