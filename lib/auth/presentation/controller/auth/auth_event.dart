part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final RegisterRequest registerRequest;

  const RegisterEvent(this.registerRequest);

  @override
  List<Object> get props => [registerRequest];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ResetPasswordEvent extends AuthEvent {
  final ResetPasswordParameters parameters;

  const ResetPasswordEvent({
    required this.parameters,
  });

  @override
  List<Object> get props => [parameters];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class TokenExpiredEvent extends AuthEvent {}
