import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/auth/repository/auth_repository.dart';
import 'login_states/login_states.dart';

class LoginViewModel extends Cubit<LoginStates> {
  final AuthRepository repository;

  LoginViewModel(this.repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      await repository.login(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(message: e.toString().replaceFirst("Exception: ", "")));
    }
  }
  Future<void> googleLogin() async {
    emit(GoogleLoading());

    try {
      final user = await repository.googleLogin();

      if (user == null) {
        emit(GoogleError("google_sign_in_aborted_by_user"));
        return;
      }

      emit(GoogleSuccess(user));
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      emit(GoogleError(message));
    }
  }
}
