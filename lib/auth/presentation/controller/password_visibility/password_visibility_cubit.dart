import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_visibility_state.dart';

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit()
      : super(const PasswordVisibilityState(
          passwordVisible: true,
          confirmPasswordVisible: true,
        ));
  void togglePassword() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));
  }
}
