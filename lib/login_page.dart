import 'package:app_test/connection_checker/bloc/connection_bloc.dart';
import 'package:app_test/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'core/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<ConnectionBloc>().add(
      CheckConnection(),
    );
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
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, textAlign: TextAlign.center,)
                ),
              );
            } else if (state is AuthRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _emailController.clear();
              _passwordController.clear();
            }
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [
                //       Color(0xFF888BF4),
                //       Color(0xFF5151C6),
                //       Color(0xFF9C0CDA),
                //       Color(0xFFC17AD1),
                //       Color(0xFF5151C6),
                //       Color(0xFF9C0CDA),
                //     ],
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //   ),
                // ),
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/library.jpg'),
                )
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/sfondo_login2.jpg'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
      
              Column(
                children: [
                  SizedBox(height: 10,),
                  BlocBuilder<ConnectionBloc, ConnectionStateTest>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: state is CurrentConnection ?
                                state.message.contains('Nessuna') ? Colors.red : Colors.greenAccent : Colors.red),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: state is CurrentConnection
                            ? Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: state.message.contains('Nessuna') ? Colors.red : Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),
                        )
                            : Text(
                          'Controllo connessione...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Container()
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'BENVENUTO',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.05
                          ..color = Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
      
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF0E8E2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: GestureDetector(
                        onTap:  () {
                          FocusScope.of(context).unfocus();
                          },
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 30),
      
                                  SizedBox(
                                    width: 270,
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        //border: OutlineInputBorder(),
                                        labelText: 'Email',
                                        floatingLabelBehavior: FloatingLabelBehavior.never
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
                                        //border: OutlineInputBorder(),
                                        labelText: 'Password',
                                        floatingLabelBehavior: FloatingLabelBehavior.never
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
      
                                  const SizedBox(height: 40),
      
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;
      
                                      return Column(
                                        children: [
                                          isLoading
                                              ? const CircularProgressIndicator()
                                              :
                                          GradientElevatedButtonPrimary(
                                            text: 'LOGIN',
                                            onPressed: _login,
                                          ),
                                          const SizedBox(height: 30),
                                          isLoading
                                              ? const SizedBox.shrink()
                                              :
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Non hai un account?',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 20
                                                ),
                                              ),
                                              // GradientElevatedButtonSecondary(
                                              //   text: 'REGISTRATI',
                                              //   onPressed: _register,
                                              // ),
                                              ElevatedButton(
                                                onPressed: () => context.pushNamed('register'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  foregroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  elevation: 0,
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                                child: ShaderMask(
                                                  shaderCallback: (bounds) => AppColors.textPrimary.createShader(
                                                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                                  ),
                                                  child: Text(
                                                    'REGISTRATI',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}