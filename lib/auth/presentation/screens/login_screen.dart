import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/admin/presentation/screens/admin_home_screen.dart';
import 'package:quiz_app/auth/domain/entities/user.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/password_visibility/password_visibility_cubit.dart';
import 'package:quiz_app/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quiz_app/auth/presentation/screens/register_screen.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/functions/hide_keyboard.dart';
import 'package:quiz_app/user/presentation/screens/user_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      hideKeyboard(context);
      context.read<AuthBloc>().add(
            LoginEvent(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              BlocSelector<PasswordVisibilityCubit, PasswordVisibilityState,
                  bool>(
                selector: (state) {
                  return state.passwordVisible;
                },
                builder: (context, visible) {
                  return TextFormField(
                    obscureText: visible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          context
                              .read<PasswordVisibilityCubit>()
                              .togglePassword();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.trim().length < 8) {
                        return 'Should be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Should contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Should contain at least one lowercase letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Should contain at least one digit';
                      }
                      if (!value.contains(RegExp(r'[@#\$%^&+=]'))) {
                        return 'Should contain at least one special character';
                      }

                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 2),
              TextButton(
                onPressed: context.watch<AuthBloc>().state is AuthLoading
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      Functions.showSnackBar(
                        context,
                        title: 'Error',
                        content: state.error,
                        icon: Icons.error_outline,
                        color: Colors.red,
                      );
                    } else if (state is Authenticated) {
                      if (state.user.role == Role.teacher) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminHomeScreen(
                                userId: state.user.id,
                                username: state.user.name),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserHomeScreen(username: state.user.name),
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) => ElevatedButton(
                  
                    onPressed: context.watch<AuthBloc>().state is AuthLoading
                        ? () {}
                        : _login,
                    child: context.watch<AuthBloc>().state is AuthLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: context.watch<AuthBloc>().state is AuthLoading
                        ? () {}
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ));
                          },
                    style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
