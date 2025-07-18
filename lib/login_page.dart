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

  // Future<void> _signInWithGoogle() async {
  //   setState(() {
  //     _isGoogleLoading = true;
  //   });
  //   try {
  //     // Avvia il flusso di accesso con Google.
  //     // Firebase Auth utilizzerà Credential Manager su Android quando disponibile.
  //     final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
  //
  //     if (googleUser == null) {
  //       // L'utente ha annullato il flusso di accesso
  //       if (mounted) {
  //         setState(() {
  //           _isGoogleLoading = false;
  //         });
  //       }
  //       return;
  //     }
  //
  //     // Ottieni i dettagli dell'autenticazione dalla richiesta.
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // Crea una nuova credenziale Firebase.
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       // accessToken: googleAuth.
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     // Accedi a Firebase con la credenziale.
  //     UserCredential userCredential = await _auth.signInWithCredential(credential);
  //
  //     if (mounted) {
  //       // Naviga alla home page o alla pagina successiva
  //       context.go('/home');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage = 'Errore durante il login con Google: ${e.message}';
  //     if (e.code == 'account-exists-with-different-credential') {
  //       errorMessage = 'Esiste già un account con questa email ma con un metodo di accesso diverso.';
  //     } else if (e.code == 'user-disabled') {
  //       errorMessage = 'L\'account utente è stato disabilitato.';
  //     }
  //     // Aggiungi altri codici di errore specifici di FirebaseAuthException se necessario
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(errorMessage)),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Si è verificato un errore imprevisto: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isGoogleLoading = false;
  //       });
  //     }
  //   }
  // }

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
        title: const Text('Login'),
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
                  'Pagina di login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la tua email';
                    }
                    if (!value.contains('@')) {
                      return 'Email non valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la tua password';
                    }
                    return null;
                  },
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
                // ElevatedButton(
                //   onPressed: _signInWithGoogle,
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 50, vertical: 15),
                //     textStyle: const TextStyle(fontSize: 16),
                //   ),
                //   child: const Text('Login Google'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
