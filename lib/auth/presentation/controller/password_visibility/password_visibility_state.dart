part of 'password_visibility_cubit.dart';

class PasswordVisibilityState extends Equatable {
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  const PasswordVisibilityState({
    required this.passwordVisible,
    required this.confirmPasswordVisible,
  });

  PasswordVisibilityState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
  }) {
    return PasswordVisibilityState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
    );
  }

  @override
  List<Object> get props => [passwordVisible, confirmPasswordVisible];
}
