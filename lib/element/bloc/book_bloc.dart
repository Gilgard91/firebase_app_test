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
    // on<AddBook>(_onAddBook);
    on<DeleteBook>(_onDeleteBook);
    on<DeleteBookAndReload>(_onDeleteBookAndReload);
    // on<BooksSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onLoadBooks(
      LoadBooks event,
      Emitter<BooksState> emit,
      ) async {
    emit(BooksLoading());
    try {
      final List<Book> books = await BookApiService.getBooks();

      emit(BooksLoaded(books: books));
    } catch (e) {
      emit(BooksError(message: 'Errore nel caricamento: $e'));
    }
  }


  Future<void> _onDeleteBookAndReload(
      DeleteBookAndReload event,
      Emitter<BooksState> emit,
      ) async {
    try {
      // Mantieni lo stato corrente durante l'operazione
      final currentState = state;
      if (currentState is BooksLoaded) {
        emit(BooksLoaded(
          books: currentState.books,
          isDeleting: true,
        ));
      }

      // Elimina il libro
      await BookApiService.deleteBook(event.bookId);

      // Ricarica i libri
      final List<Book> books = await BookApiService.getBooks();

      emit(BooksLoaded(books: books));
    } catch (e) {
      emit(BooksError(message: 'Errore nell\'eliminazione: $e'));
    }
  }

  // Future<void> _onAddBook(
  //     AddBook event,
  //     Emitter<BooksState> emit,
  //     ) async {
  //   try {
  //     final Book = Book(
  //       id: '', // Firestore genererà l'ID
  //       name: event.name,
  //       birthYear: event.birthYear,
  //       userId: event.userId,
  //     );
  //
  //     await _firestore.collection('Musicisti').add(Book.toFirestore());
  //
  //     // Mantieni la lista corrente e aggiungi il messaggio di successo
  //     final currentState = state;
  //     if (currentState is BooksLoaded) {
  //       emit(BookAdded(
  //         message: 'Musicista aggiunto con successo!',
  //         Books: currentState.Books,
  //       ));
  //     } else {
  //       emit(const BookAdded(
  //         message: 'Musicista aggiunto con successo!',
  //         Books: [],
  //       ));
  //     }
  //
  //     // Lo stream si aggiornerà automaticamente con i nuovi dati
  //   } catch (e) {
  //     emit(BooksError(message: 'Errore nell\'aggiunta: $e'));
  //   }
  // }
  //
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
  //
  // Stream<int> testStream() async* {
  //   for (int i = 1; i <= 10; i++) {
  //     debugPrint("sendo il numero $i");
  //     await Future.delayed(Duration(seconds: 2));
  //     yield i;
  //   }
  // }
  //
  // Future<void> _onSubscriptionRequested(
  //     BooksSubscriptionRequested event,
  //     Emitter<BooksState> emit,
  //     ) async {
  //   emit(BooksLoading());
  //   Stream<int> stream = testStream();
  //   stream.listen((data) {
  //     debugPrint("ricevuto il numero $data");
  //   });
  //   await _BooksSubscription?.cancel();
  //
  //   // Usa emit.forEach per gestire gli stream in modo sicuro
  //   await emit.forEach<QuerySnapshot>(
  //     _firestore
  //         .collection('Musicisti')
  //         .where('userId', isEqualTo: event.userId)
  //         .snapshots(),
  //     onData: (snapshot) {
  //       final Books = snapshot.docs
  //           .map((doc) => Book.fromFirestore(doc))
  //           .toList();
  //       return BooksLoaded(Books: Books);
  //     },
  //     onError: (error, stackTrace) {
  //       return BooksError(message: 'Errore nel caricamento: $error');
  //     },
  //   );
  // }

  @override
  Future<void> close() {
    // Non serve più cancellare _BooksSubscription
    // perché emit.forEach lo gestisce automaticamente
    return super.close();
  }
}