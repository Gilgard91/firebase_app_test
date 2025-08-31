import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../element/bloc/book.dart';
import '../element/bloc/book_bloc.dart';
import '../element/bloc/book_event.dart';
import '../element/bloc/book_state.dart';
import '../element/bloc/google_book_bloc.dart';
import '../home_page.dart';

class HomeBlocHelper {

  static Widget buildStickyHeader(GoogleBooksState state, String subject, {Color color = const Color(0xFF8552CC)}) {
    if (state is GoogleBooksLoaded) {
      List<Book> books;
      switch (subject.toLowerCase()) {
        case 'thriller':
          books = state.thrillerBooks;
          break;
        case 'adventure':
          books = state.adventureBooks;
          break;
        default:
          books = state.thrillerBooks;
      }

      return SliverPersistentHeader(
        pinned: true,
        delegate: StickyHeaderDelegate(
          child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            child: Center(
              child: Text(
                books.isNotEmpty ? subject.toUpperCase() : 'N.D.',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
  }

  static Widget buildBooksContent(
      BuildContext context,
      GoogleBooksState state, {
        required Widget Function(Book) bookCoverBuilder,
        required String bookType,
      }) {
    // if (state is BooksLoading) {
    //   return _buildLoadingState();
    // } else
    if (state is GoogleBooksLoaded) {
      return _buildLoadedState(state, bookCoverBuilder, bookType);
    } else if (state is GoogleBooksError) {
      return _buildErrorState(context, state);
    }
    return _buildDefaultState();
  }

  static Widget _buildLoadingState() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static Widget _buildLoadedState(
      GoogleBooksLoaded state,
      Widget Function(Book) bookCoverBuilder,
      String bookType,
      ) {
    List<Book> books;
    switch (bookType.toLowerCase()) {
      case 'thriller':
        books = state.thrillerBooks;
        break;
      case 'adventure':
        books = state.adventureBooks;
        break;
      default:
        books = state.thrillerBooks;
    }

    if (books.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'Nessun libro trovato.\nTocca "+" per aggiungerne uno.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return bookCoverBuilder(books[index]);
          },
          childCount: books.length,
        ),
      ),
    );
  }

  static Widget _buildErrorState(BuildContext context, GoogleBooksError state) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Errore: ${state.message}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _handleRetry(context),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDefaultState() {
    return const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
  }

  static void _handleRetry(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BooksBloc>().add(
        LoadBooks(userId: authState.userId),
      );
    }
  }
}