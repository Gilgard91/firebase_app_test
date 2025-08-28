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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Avvia la sottoscrizione ai musicisti quando la pagina si carica
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
    _nameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  void _addBook() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final name = _nameController.text.trim();
      final birthYear = int.tryParse(_birthYearController.text.trim());

      if (name.isNotEmpty && birthYear != null) {
        context.read<BooksBloc>().add(
          AddBook(
            name: name,
            birthYear: birthYear,
            userId: authState.userId,
          ),
        );
      }
    }
  }

  Future<void> _showAddBookDialog() async {
    _nameController.clear();
    _birthYearController.clear();

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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore, inserisci un nome.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _birthYearController,
                    decoration: const InputDecoration(labelText: 'Anno di nascita'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore, inserisci l\'anno di nascita.';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Per favore, inserisci un numero valido.';
                      }
                      return null;
                    },
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

  // Widget _buildBookItem(Book book) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //     child: ListTile(
  //       title: Text(book.title!),
  //       subtitle: Text('Autore: ${book.author}'),
  //       trailing: IconButton(
  //         icon: const Icon(Icons.delete, color: Colors.red),
  //         onPressed: () {
  //           context.read<BooksBloc>().add(
  //             DeleteBook(bookId: book.id!),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBookItem(Book book) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con titolo e pulsante elimina
              Row(
                children: [
                  Expanded(
                    child: Text(
                      book.title ?? 'Titolo non disponibile',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () {
                      _showDeleteConfirmation(context, book);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Autore
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.author?.isNotEmpty == true
                          ? book.author!
                          : 'Autore sconosciuto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Descrizione (se presente)
              if (book.description?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          book.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Footer con ID (opzionale, per debug)
              if (book.id != null) ...[
                const SizedBox(height: 8),
                Text(
                  'ID: ${book.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

// Metodo helper per la conferma di eliminazione
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
              // SliverAppBar sostituisce AppBar
              SliverAppBar(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                pinned: true, // Rimane sempre visibile
                expandedHeight: 120, // Altezza quando espansa
                flexibleSpace: FlexibleSpaceBar(
                  // Puoi aggiungere un background o altri elementi qui
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: _logout,
                  )
                ],
              ),
      
              // Header con informazioni utente
              BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Benvenuto, ${state.email}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
      
              SliverPersistentHeader(
                pinned: true,
                delegate: MyStickyHeaderDelegate(
                  child: Container(
                    color: Colors.green,
                    child: Center(child: Text('LIBRI', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),)),
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
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return _buildBookItem(state.books[index]);
                        },
                        childCount: state.books.length,
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
                backgroundColor: Colors.blue,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.refresh),
                    label: 'Aggiorna',
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
                    backgroundColor: Colors.green,
                    onTap: _showAddBookDialog,
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

class MyStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  MyStickyHeaderDelegate({
    required this.child,
    this.height = 60.0,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      width: double.infinity,
      child: child,
    );
  }

  @override
  bool shouldRebuild(MyStickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}