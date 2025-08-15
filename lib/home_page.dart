import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'element/bloc/musician.dart';
import 'element/bloc/musician_bloc.dart';
import 'element/bloc/musician_event.dart';
import 'element/bloc/musician_state.dart';

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
      context.read<MusiciansBloc>().add(
        MusiciansSubscriptionRequested(userId: authState.userId),
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

  void _addMusician() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final name = _nameController.text.trim();
      final birthYear = int.tryParse(_birthYearController.text.trim());

      if (name.isNotEmpty && birthYear != null) {
        context.read<MusiciansBloc>().add(
          AddMusician(
            name: name,
            birthYear: birthYear,
            userId: authState.userId,
          ),
        );
      }
    }
  }

  Future<void> _showAddMusicianDialog() async {
    _nameController.clear();
    _birthYearController.clear();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Aggiungi Nuovo Musicista'),
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
            BlocConsumer<MusiciansBloc, MusiciansState>(
              listener: (context, state) {
                if (state is MusicianAdded) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is MusiciansError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is MusiciansLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      _addMusician();
                    }
                  },
                  child: state is MusiciansLoading
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

  Widget _buildMusicianItem(Musician musician) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(musician.name),
        subtitle: Text('Anno di nascita: ${musician.birthYear}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context.read<MusiciansBloc>().add(
              DeleteMusician(musicianId: musician.id),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Homepage'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          )
        ],
      ),
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
          BlocListener<MusiciansBloc, MusiciansState>(
            listener: (context, state) {
              if (state is MusiciansError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            // Header con informazioni utente
            BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Benvenuto, ${state.email}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Lista musicisti
            Expanded(
              child: BlocBuilder<MusiciansBloc, MusiciansState>(
                builder: (context, state) {
                  if (state is MusiciansLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MusiciansLoaded) {
                    if (state.musicians.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nessun musicista trovato.\nTocca "+" per aggiungerne uno.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.musicians.length,
                      itemBuilder: (context, index) {
                        return _buildMusicianItem(state.musicians[index]);
                      },
                    );
                  } else if (state is MusiciansError) {
                    return Center(
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
                                context.read<MusiciansBloc>().add(
                                  LoadMusicians(userId: authState.userId),
                                );
                              }
                            },
                            child: const Text('Riprova'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Text('Effettua il login per vedere i tuoi musicisti.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return FloatingActionButton(
              onPressed: _showAddMusicianDialog,
              tooltip: 'Aggiungi Musicista',
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}