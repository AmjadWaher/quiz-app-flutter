import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/auth/domain/entities/user.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/password_visibility/password_visibility_cubit.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/functions/hide_keyboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _role;

  void _register() {
    hideKeyboard(context);
    if (!_formKey.currentState!.validate() || _role == null) {
      if (_role == null) {
        Functions.showSnackBar(
          context,
          title: 'Error',
          content: 'Please select a role',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      }
      return;
    }
    context.read<AuthBloc>().add(
          RegisterEvent(
            RegisterRequest(
              username: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
              role: _role!,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _role = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      if (value.trim().length < 4) {
                        return 'Should be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
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
                  SizedBox(height: 16),
                  BlocSelector<PasswordVisibilityCubit, PasswordVisibilityState,
                      bool>(
                    selector: (state) {
                      return state.confirmPasswordVisible;
                    },
                    builder: (context, visible) {
                      return TextFormField(
                        obscureText: visible,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              visible ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              context
                                  .read<PasswordVisibilityCubit>()
                                  .toggleConfirmPassword();
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value != _passwordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu(
                    width: double.infinity,
                    hintText: 'Select Role',
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: Role.teacher.name, label: 'Teacher'),
                      DropdownMenuEntry(
                          value: Role.student.name, label: 'Student'),
                    ],
                    onSelected: (value) {
                      _role = value;
                    },
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
                        } else if (state is Response) {
                          Functions.showSnackBar(
                            context,
                            title: 'Success',
                            content: state.message,
                            icon: Icons.info_outline,
                            color: Colors.green,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) => ElevatedButton(
                        onPressed:
                            context.watch<AuthBloc>().state is AuthLoading
                                ? () {}
                                : _register,
                        child: context.watch<AuthBloc>().state is AuthLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Register'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed:
                            context.watch<AuthBloc>().state is AuthLoading
                                ? () {}
                                : () {
                                    Navigator.of(context).pop();
                                  },
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
