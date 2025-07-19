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
            Text(
              user != null ? 'Benvenuto, ${user.email}' : 'Pagina homepage',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Musicisti').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Nessun musicista trovato.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => _buildList(context, snapshot.data!.docs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
