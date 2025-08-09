import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Registrazione'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Pulisci i campi dopo registrazione riuscita
            _emailController.clear();
            _passwordController.clear();
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Accesso o Registrazione',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 270,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci l\'email';
                        }
                        if (!value.contains('@')) {
                          return 'Inserisci un\'email valida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 270,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la password';
                        }
                        if (value.length < 6) {
                          return 'La password deve essere di almeno 6 caratteri';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return Column(
                        children: [
                          isLoading
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
                          const SizedBox(height: 15),
                          isLoading
                              ? const SizedBox.shrink()
                              : ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text(
                              'Registrati',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}