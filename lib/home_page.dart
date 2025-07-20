import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore durante il logout: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  Widget _buildList(BuildContext context, DocumentSnapshot doc) {
    return Column(
      children: [
        ListTile(
          title: Row(children: [
            Expanded(child: Text("${doc['Nome']} - ${doc['Anno di nascita'].toString()}"))
          ]),
        ),
      ],
    );
  }

  Future<void> addMusician(String name, int birthYear) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Devi essere loggato per aggiungere un elemento.')),
        );
      }
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Musicisti').add({
        'Nome': name,
        'Anno di nascita': birthYear,
        'userId': user.uid,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elemento aggiunto con successo!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'aggiunta dell\'elemento: $e')),
        );
      }
      print('Errore durante l\'aggiunta dell\'elemento: $e');
    }
  }

  Future<void> _showAddMusicianDialog() async {
    _nameController.clear();
    _birthYearController.clear();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Nuovo elemento'),
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
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Aggiungi'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final String name = _nameController.text;
                  final int? birthYear = int.tryParse(_birthYearController.text);

                  if (birthYear != null) {
                    addMusician(name, birthYear);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Anno di nascita non valido.')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout', onPressed: _logout)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                user != null ? 'Benvenuto, ${user.email}' : 'Pagina homepage',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: user != null
                    ? FirebaseFirestore.instance
                    .collection('Musicisti')
                    .where('userId', isEqualTo: user.uid)
                    .snapshots()
                    : Stream.empty(),
                builder: (context, snapshot) {
                  if (user == null) {
                    return const Center(child: Text('Effettua il login per vedere i tuoi elementi.'));
                  }
                  if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Nessun elemento trovato. Tocca "+" per aggiungerne uno.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        _buildList(context, snapshot.data!.docs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMusicianDialog,
        tooltip: 'Aggiungi Elemento',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
