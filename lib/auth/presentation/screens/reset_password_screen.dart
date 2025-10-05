import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/password_visibility/password_visibility_cubit.dart';
import 'package:quiz_app/auth/presentation/screens/login_screen.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/functions/hide_keyboard.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.token});
  final String? email;
  final String? token;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    hideKeyboard(context);

    context.read<AuthBloc>().add(ResetPasswordEvent(
          parameters: ResetPasswordParameters(
            email: widget.email!,
            token: widget.token!,
            newPassword: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BlocSelector<PasswordVisibilityCubit, PasswordVisibilityState,
                  bool>(
                selector: (state) {
                  return state.passwordVisible;
                },
                builder: (context, state) {
                  return TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          state ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          context
                              .read<PasswordVisibilityCubit>()
                              .togglePassword();
                        },
                      ),
                    ),
                    obscureText: state,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.trim().length < 8) {
                        return 'Should be at least 8 characters';
                      }
                      if (value.contains(RegExp('r[A-Z]'))) {
                        return 'Should contain at least one uppercase letter';
                      }
                      if (value.contains(RegExp('r[a-z]'))) {
                        return 'Should contain at least one lowercase letter';
                      }
                      if (value.contains(RegExp('r[0-9]'))) {
                        return 'Should contain at least one digit';
                      }
                      if (value.contains(RegExp('r[@#\$%^&+=]'))) {
                        return 'Should contain at least one special character';
                      }

                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocSelector<PasswordVisibilityCubit, PasswordVisibilityState,
                  bool>(
                selector: (state) {
                  return state.confirmPasswordVisible;
                },
                builder: (context, state) {
                  return TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          state ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          context
                              .read<PasswordVisibilityCubit>()
                              .toggleConfirmPassword();
                        },
                      ),
                    ),
                    obscureText: state,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value != _passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    Functions.showSnackBar(
                      context,
                      title: 'Error',
                      content: state.error,
                      icon: Icons.error_outline,
                      color: Colors.red,
                    );
                  } else if (state is Response) {
                    Functions.showSnackBar(
                      context,
                      title: 'Success',
                      content: state.message,
                      icon: Icons.info_outline,
                      color: Colors.green,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading ? () {} : _resetPassword,
                    child: state is AuthLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Reset Password'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
