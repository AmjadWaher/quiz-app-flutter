import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/functions/hide_keyboard.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address to reset your password.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Response) {
                  Functions.showSnackBar(
                    context,
                    title: 'Success',
                    content: state.message,
                    icon: Icons.info_outline,
                    color: Colors.blue,
                  );
                } else if (state is AuthError) {
                  Functions.showSnackBar(
                    context,
                    title: 'Error',
                    content: state.error,
                    icon: Icons.error_outline,
                    color: Colors.red,
                  );
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading
                        ? () {}
                        : () {
                            final email = _emailController.text.trim();
                            if (email.isNotEmpty && email.contains('@')) {
                              hideKeyboard(context);
                              context.read<AuthBloc>().add(
                                    ForgotPasswordEvent(email),
                                  );
                            } else {
                              Functions.showSnackBar(
                                context,
                                title: 'Error',
                                content: 'Please enter a valid email address.',
                                icon: Icons.error_outline,
                                color: Colors.red,
                              );
                            }
                          },
                    child: state is AuthLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Reset Password'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
