import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isRegistering = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: 'test');

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          context.go('/home');
        }

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Nessun utente trovato per questa email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Password errata.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'L\'indirizzo email non è valido.';
        } else {
          errorMessage = 'Errore durante il login: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Si è verificato un errore: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = true;
      });
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Opzionale: puoi salvare informazioni aggiuntive dell'utente
        // nel database Firestore o Realtime Database qui.
        // Esempio:
        // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        //   'email': _emailController.text.trim(),
        //   // altri campi...
        // });

        await FirebaseAuth.instance.signOut();

        if (mounted) {
          // context.go('/home'); // O mostra una SnackBar di successo e resta sulla pagina di login
          // // per far accedere l'utente.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrazione avvenuta con successo! Effettua il login.')),
          );
        }

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'La password fornita è troppo debole.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'L\'account esiste già per questa email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'L\'indirizzo email non è valido.';
        } else {
          errorMessage = 'Errore durante la registrazione: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Si è verificato un errore: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isRegistering = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Registrazione'), // Titolo aggiornato
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Accesso o Registrazione', // Testo aggiornato
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  // ... (configurazione TextFormField email esistente) ...
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  // ... (configurazione TextFormField password esistente) ...
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 15), // Spazio tra i pulsanti
                _isRegistering
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _register, // Chiama la nuova funzione di registrazione
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Colore diverso per la registrazione
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Registrati'),
                ),
                // ... (Eventuale pulsante Google Sign-In) ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
