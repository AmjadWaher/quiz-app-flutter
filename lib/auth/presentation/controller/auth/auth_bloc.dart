import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quiz_app/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quiz_app/auth/domain/entities/user.dart';
import 'package:quiz_app/auth/domain/usecase/login_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  AuthBloc(
    this.loginUsecase,
    this.registerUsecase,
    this.forgotPasswordUsecase,
    this.resetPasswordUsecase,
    this.sharedPreferences,
    this.secureStorage,
  ) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUsecase(
      LoginParameters(
        email: event.email,
        password: event.password,
      ),
    );

    await sharedPreferences.clear();
    await secureStorage.deleteAll();

    await result.fold(
      (failure) {
        emit(AuthError(error: failure.message));
      },
      (user) async {
        await sharedPreferences.setString('username', user.name);
        await sharedPreferences.setString('role', user.role.name);

        await secureStorage.write(key: 'id', value: user.id);
        await secureStorage.write(key: 'email', value: user.email);
        await secureStorage.write(key: 'token', value: user.token);

        emit(
          Authenticated(
            token: user.token,
            user: user,
          ),
        );
      },
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUsecase(event.registerRequest);

    result.fold(
      (failure) {
        emit(AuthError(error: failure.message));
      },
      (response) async {
        emit(Response(message: response.message));
      },
    );
  }

  void _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await forgotPasswordUsecase(event.email);

    result.fold(
      (failure) {
        emit(AuthError(error: failure.message));
      },
      (response) async {
        emit(Response(message: response.message));
      },
    );
  }

  void _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await resetPasswordUsecase(event.parameters);

    result.fold(
      (failure) {
        emit(AuthError(error: failure.message));
      },
      (response) async {
        emit(Response(message: response.message));
      },
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await sharedPreferences.clear();
    await secureStorage.deleteAll();
    emit(Unauthenticated());
  }

  void _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await secureStorage.read(key: 'token');
      final id = await secureStorage.read(key: 'id');
      final email = await secureStorage.read(key: 'email');
      final username = sharedPreferences.getString('username');
      final role = sharedPreferences.getString('role');

      log(token.toString());
      log(role.toString());

      if (token != null && JwtDecoder.isExpired(token)) {
        await sharedPreferences.clear();
        await secureStorage.deleteAll();
        emit(Unauthenticated());
        log('Token expired');
        return;
      }

      if (token != null &&
          id != null &&
          username != null &&
          email != null &&
          role != null) {
        emit(
          Authenticated(
            token: token,
            user: User(
              id: id,
              name: username,
              email: email,
              role: Role.values.firstWhere((e) => e.name == role),
              token: token,
            ),
          ),
        );
        log('User authenticated');
      } else {
        emit(Unauthenticated());
        log('User not authenticated');
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
      log('Error: $e');
    }
  }
}
