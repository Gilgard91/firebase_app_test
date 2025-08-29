import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'element/bloc/book.dart';
import 'element/bloc/book_bloc.dart';
import 'element/bloc/book_event.dart';
import 'element/bloc/book_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(text: '');


  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    // final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      context.read<BooksBloc>().add(
        LoadBooks(userId: authState.userId),
      );

    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  void _addBook() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final title = _titleController.text.trim();
      final author = _authorController.text.trim();
      final description = _descriptionController.text.trim();

      if (title.isNotEmpty && author.isNotEmpty) {
        context.read<BooksBloc>().add(
          AddBook(
            title: title,
            author: author,
            description: description,
          ),
        );
      }
    }
  }

  Future<void> _showAddBookDialog() async {
    _titleController.clear();
    _authorController.clear();
    _descriptionController.clear();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Aggiungi Nuovo Libro'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Titolo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore, inserisci un titolo.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Autore'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore, inserisci un autore.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrizione'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            BlocConsumer<BooksBloc, BooksState>(
              listener: (context, state) {
                if (state is BookAdded) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is BooksError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is BooksLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      _addBook();
                      context.read<BooksBloc>().add(
                        LoadBooks(),
                      );
                    }
                  },
                  child: state is BooksLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Aggiungi'),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildBookCover(Book book) {
    final colors = [
      [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      [Color(0xFF10B981), Color(0xFF059669)],
      [Color(0xFFF59E0B), Color(0xFFD97706)],
      [Color(0xFFEF4444), Color(0xFFDC2626)],
      [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      [Color(0xFF06B6D4), Color(0xFF0891B2)],
      [Color(0xFF84CC16), Color(0xFF65A30D)],
      [Color(0xFFF97316), Color(0xFFEA580C)],
      [Color(0xFFEC4899), Color(0xFFDB2777)],
    ];

    final colorIndex = (book.title?.hashCode ?? 0).abs() % colors.length;
    final gradientColors = colors[colorIndex];

    return GestureDetector(
      onTap: () {

      },
      onLongPress: () {

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Pattern di sfondo opzionale
                // Positioned.fill(
                //   child: Opacity(
                //     opacity: 0.1,
                //     child: Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: NetworkImage(
                //           ),
                //           repeat: ImageRepeat.repeat,
                //           fit: BoxFit.none,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // Contenuto principale
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Pulsante elimina
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 20,
                                ), onPressed: () {
                                _showDeleteConfirmation(context, book);
                              },
                              ),
                            ),

                        ],
                      ),

                      const Spacer(),

                      // Titolo del libro
                      Text(
                        book.title ?? 'Titolo non disponibile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 2,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Autore
                      Text(
                        book.author?.isNotEmpty == true
                            ? book.author!
                            : 'Autore sconosciuto',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// conferma di eliminazione
  void _showDeleteConfirmation(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<BooksBloc, BooksState>(
          listener: (context, state) {
            // Ascolta i cambiamenti di stato
            if (state is BooksLoaded && state.isDeleting != true) {
              // Se i libri sono stati ricaricati e non siamo più in fase di eliminazione
              context.pop();
            } else if (state is BooksError) {
              // In caso di errore, chiudi il dialog e mostra l'errore
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_outlined, color: Colors.orange),
                SizedBox(width: 12),
                Text('Conferma eliminazione'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sei sicuro di voler eliminare il libro "${book.title}"?',
                  style: const TextStyle(fontSize: 16),
                ),
                // mostra un indicatore di caricamento se stiamo eliminando
                BlocBuilder<BooksBloc, BooksState>(
                  builder: (context, state) {
                    if (state is BooksLoaded && state.isDeleting == true) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: LinearProgressIndicator(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            actions: [
              BlocBuilder<BooksBloc, BooksState>(
                builder: (context, state) {
                  final isDeleting = state is BooksLoaded && state.isDeleting == true;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
                        child: Text(
                          'Annulla',
                          style: TextStyle(
                            color: isDeleting ? Colors.grey : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isDeleting ? null : () {
                          context.read<BooksBloc>().add(
                            DeleteBookAndReload(bookId: book.id!),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDeleting ? Colors.grey : Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isDeleting
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Text('Elimina'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return SafeArea(
      top: false,
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  context.go('/login');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
            BlocListener<BooksBloc, BooksState>(
              listener: (context, state) {
                if (state is BooksError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: CustomScrollView(
            slivers: [

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return SliverAppBar(
                      backgroundColor: const Color(0xFF5151C6),
                      foregroundColor: Colors.white,
                      pinned: true,
                      expandedHeight: 130,
                      //centerTitle: true,
                      // title: Text('Benvenuto, ${state.name}'),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Benvenuto, ${state.name}', style: TextStyle(color: Color(0xFFFFFAC4)),),
                        background: Image(
                          fit: BoxFit.cover,
                          // image: NetworkImage('https://i.redd.it/wetnhnvrvdpb1.jpg', ),
                          image: AssetImage('assets/images/sfondo_login2.jpg'),
                        ),
                        centerTitle: true,
                      ),
                    );
                  }

                  return const SliverAppBar(
                    backgroundColor: Color(0xFF5151C6),
                    foregroundColor: Colors.white,
                    pinned: true,
                    expandedHeight: 80,
                    title: Text('Caricamento...'),
                  );
                },
              ),


              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  child: Container(
                    color: Color(0xFF8552CC),
                    child: Center(child: Text('LIBRERIA', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),


              // Lista libri con SliverList
              BlocBuilder<BooksBloc, BooksState>(
                builder: (context, state) {
                  if (state is BooksLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (state is BooksLoaded) {
                    if (state.books.isEmpty) {
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
                          crossAxisCount: 2, // 2 colonne
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.7, // Ratio per simulare un libro (più alto che largo)
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return _buildBookCover(state.books[index]);
                          },
                          childCount: state.books.length,
                        ),
                      ),
                    );
                  } else if (state is BooksError) {
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
                                onPressed: () {
                                  final authState = context.read<AuthBloc>().state;
                                  if (authState is AuthAuthenticated) {
                                    context.read<BooksBloc>().add(
                                      LoadBooks(userId: authState.userId),
                                    );
                                  }
                                },
                                child: const Text('Riprova'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text('Effettua il login per vedere i tuoi libri.'),
                      ),
                    ),
                  );
                },
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  child: Container(
                    color: Color(0xFFA9CC52),
                    child: Center(child: Text('Altre cose', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              BlocBuilder<BooksBloc, BooksState>(
                builder: (context, state) {
                  if (state is BooksLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (state is BooksLoaded) {
                    if (state.books.isEmpty) {
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
                          crossAxisCount: 2, // 2 colonne
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.7, // Ratio per simulare un libro (più alto che largo)
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return _buildBookCover(state.books[index]);
                          },
                          childCount: state.books.length,
                        ),
                      ),
                    );
                  } else if (state is BooksError) {
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
                                onPressed: () {
                                  final authState = context.read<AuthBloc>().state;
                                  if (authState is AuthAuthenticated) {
                                    context.read<BooksBloc>().add(
                                      LoadBooks(userId: authState.userId),
                                    );
                                  }
                                },
                                child: const Text('Riprova'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text('Effettua il login per vedere i tuoi libri.'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: const Color(0xFF5151C6),
                foregroundColor: Colors.white,
                overlayColor: Colors.black,
                overlayOpacity: 0.6,
                childMargin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.refresh),
                    label: 'Aggiorna',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    onTap: () {
                      context.read<BooksBloc>().add(
                        LoadBooks(),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.add),
                    label: 'Aggiungi libro',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    onTap: _showAddBookDialog,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.logout),
                    label: 'Logout',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    onTap: _logout,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  StickyHeaderDelegate({
    required this.child,
    this.height = 60.0,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: child,
    );
  }

  @override
  bool shouldRebuild(StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}