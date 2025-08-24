import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF888BF4),
                    Color(0xFF5151C6),
                    Color(0xFF9C0CDA),
                    Color(0xFFC17AD1),
                    Color(0xFF5151C6),
                    Color(0xFF9C0CDA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

            ),
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/images/sfondo_login.jpg'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container()
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'REGISTRAZIONE',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.2
                        ..color = Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthRegistrationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message, textAlign: TextAlign.center)),
                      );
                      _emailController.clear();
                      _passwordController.clear();
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(state.message, textAlign: TextAlign.center,)
                        ),
                      );
                    }
                  },
                  child: Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
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

                                  // Campo nome
                                  SizedBox(
                                    width: 270,
                                    child: TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        //border: OutlineInputBorder(),
                                          labelText: 'Nome',
                                          floatingLabelBehavior: FloatingLabelBehavior.never
                                      ),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Inserisci il nome';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Campo Email
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

                                  // Campo Password
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

                                  // Pulsanti
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;

                                      return Column(
                                        children: [
                                          isLoading
                                              ? const CircularProgressIndicator()
                                              : GradientElevatedButtonPrimary(
                                            text: 'REGISTRATI',
                                            onPressed: _register,
                                          ),
                                          const SizedBox(height: 30),

                                          ElevatedButton(
                                            onPressed: () => context.pop(),
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
                                              shaderCallback: (bounds) =>
                                                  AppColors.textPrimary.createShader(
                                                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                                  ),
                                              child: Text(
                                                'ANNULLA',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}