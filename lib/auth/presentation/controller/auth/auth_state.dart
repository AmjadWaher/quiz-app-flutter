part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final User user;
  const Authenticated({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}

class Unauthenticated extends AuthState {}

class Response extends AuthState {
  final String message;
  const Response({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  final String error;
  const AuthError({required this.error});

  @override
  List<Object> get props => [error];
}
