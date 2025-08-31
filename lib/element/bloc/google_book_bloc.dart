import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../api/BooksApiService.dart';
import 'book.dart';

part 'google_book_event.dart';
part 'google_book_state.dart';

class GoogleBooksBloc extends Bloc<GoogleBooksEvent, GoogleBooksState> {
  GoogleBooksBloc() : super(GoogleBookInitial()) {

    on<LoadGoogleBooks>(_onLoadGoogleBooks);
  }

  Future<void> _onLoadGoogleBooks(
      LoadGoogleBooks event,
      Emitter<GoogleBooksState> emit,
      ) async {
    emit(GoogleBooksLoading());

    List<Book> thrillerBooks = [];
    List<Book> adventureBooks = [];

    try {
      thrillerBooks = await BookApiService.getBooks(subject: 'thriller');
    } catch (e) {
      debugPrint('Errore caricamento thriller: $e');
    }

    try {
      adventureBooks = await BookApiService.getBooks(subject: 'adventure');
    } catch (e) {
      debugPrint('Errore caricamento adventure: $e');
    }


    emit(GoogleBooksLoaded(
      thrillerBooks: thrillerBooks,
      adventureBooks: adventureBooks,
    ));
  }
}
